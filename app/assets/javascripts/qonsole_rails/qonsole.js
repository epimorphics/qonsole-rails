/* Copyright (c) 2012-2016 Epimorphics Ltd. Released under Apache License 2.0 http://www.apache.org/licenses/ */

modulejs.define( "qonsole", [
  "lib/lodash",
  "lib/jquery",
  "lib/codemirror",
  "sprintf",
  "lib/util",
  "sparql-service-result"
], function(
  _,
  $,
  CodeMirror,
  Sprintf,
  Util,
  SparqlServiceResult
) {
  "use strict";

  /* --- module vars --- */
  var _queryEditor = null;
  var _startTime = 0;
  var _outstandingQueries = 0;
  var _config;


  /** Initialisation - only called once */
  var init = function() {
    bindEvents();

    $.ajaxSetup( {
      converters: {"script json": true}
    } );

    const currentUrl = new URL(window.location);

    let params = currentUrl.searchParams;


    if (params.has('query')) {
      let queryParams = params.get('query');
      showGivenQuery( queryParams );
    }
    else {
      setFirstQueryActive();
    }
  };

  var config = function() {
    return _config;
  };

  /** Bind events that we want to manage */
  var bindEvents = function() {
    $("ul.prefixes").on( "click", "input[type=checkbox]", function( e ) {
      var elem = $(e.currentTarget);
      updatePrefixDeclaration( $.trim( elem.parent().text() ), elem.val(), elem.is(":checked") );
    } );
    $("ul.examples").on( "click", "input[type=button]", function( e ) {
      var elem = $(e.currentTarget);
      $("ul.examples input").removeClass( "active" );
      $(elem).addClass( "active" );
      _.defer( function() {showCurrentQuery();} );
    } );
    $(".endpoints").on( "click", "a", function( e ) {
      var elem = $(e.currentTarget);
      setCurrentEndpoint( $.trim( elem.text() ) );
    } );
    $("ul.formats").on( "click", "a", function( e ) {
      var elem = $(e.currentTarget);
      setCurrentFormat( elem.data( "value" ), $.trim( elem.text() ) );
    } );

    $("input.run-query").on( "click", runQuery );

    $(document)
      .ajaxStart(function() {
        elementVisible( ".loadingSpinner", true );
        startTimingResults();
      })
      .ajaxStop(function() {
        elementVisible( ".loadingSpinner", false );
      });

    // dialogue events
    $("#prefixEditor").on( "click", "#lookupPrefix", onLookupPrefix )
                      .on( "keyup", "#inputPrefix", function( e ) {
                        var elem = $(e.currentTarget);
                        $("#lookupPrefix span").text( Sprintf.sprintf( "'%s'", elem.val() ));
                      } );
    $("#addPrefix").on( "click", onAddPrefix );
  };

  /** Display the given query */
  var showGivenQuery = function( query ) {
    if (query === "_localstore") {
      query = Util.Browser.getSessionStore( "qonsole.query" );
      if (window.location.hostname === "localhost" && !query) {
        console.error('No query found in local storage due to cross-origin blocking. Please check the sessionStorage tab in your browser\'s dev tools for the SPARQL query value.')
      }
    }
    displayQuery( query );
  };

  /** Set the default active query */
  var setFirstQueryActive = function() {
    if (_outstandingQueries === 0) {
      $("ul.examples").find("input[type=button]").first().addClass( "active" );
      showCurrentQuery();
    }
  };

  /** Set the current endpoint text */
  var setCurrentEndpoint = function( url ) {
    $("[id=sparqlEndpoint]").val( url );
  };

  /** Return the current endpoint text */
  var currentEndpoint = function() {
    return $("[id=sparqlEndpoint]").val();
  };

  /** Return the currently active named example */
  var currentNamedExample = function() {
    return $("ul.examples input.active").first().data( "query" );
  };

  /** Return the DOM node representing the query editor */
  var queryEditor = function() {
    if (!_queryEditor) {
      _queryEditor = new CodeMirror( $("#query-edit-cm").get(0), {
        lineNumbers: true,
        mode: "sparql"
      } );
    }
    return _queryEditor;
  };

  /** Return the current value of the query edit area */
  var currentQueryText = function() {
    return queryEditor().getValue();
  };

  /** Set the value of the query edit area */
  var setCurrentQueryText = function( text ) {
    queryEditor().setValue( text );
  };

  /** Display the given query, with the currently defined prefixes */
  var showCurrentQuery = function() {
    var query = currentNamedExample();
    displayQuery( query );
  };

  /** Display the given query */
  var displayQuery = function( query ) {
    if (query) {
      var queryBody = query.query ? query.query : query;
      var prefixes = assemblePrefixes( queryBody, query.prefixes );

      var q = Sprintf.sprintf( "%s\n\n%s", renderPrefixes( prefixes ), stripLeader( queryBody ) );
      setCurrentQueryText( q );

      syncPrefixButtonState( prefixes );
    }
  };

  /** Return the currenty selected output format */
  var selectedFormat = function() {
    return $("a.display-format").data( "value" );
  };

  /** Update the user's format selection */
  var setCurrentFormat = function( val, label ) {
    $("a.display-format").data( "value", val ).find("span").text( label );
  };

  /** Assemble the set of prefixes to use when initially rendering the query */
  var assemblePrefixes = function( queryBody, queryDefinitionPrefixes ) {
    if (queryBody.match( /^prefix/i )) {
      // strategy 1: there are prefixes encoded in the query body
      return assemblePrefixesFromQuery( queryBody );
    }
    else if (queryDefinitionPrefixes) {
      // strategy 2: prefixes given in query def
      return _.map( queryDefinitionPrefixes, function( prefixName ) {
        return {name: prefixName, uri: config().prefixes[prefixName] };
      } );
    }
    else {
      return assembleCurrentPrefixes();
    }
  };

  /** Return an array comprising the currently selected prefixes */
  var assembleCurrentPrefixes = function() {
    var l = $("ul.prefixes input[type=checkbox]:checked" ).map( function( i, elt ) {
      return {name: $.trim( $(elt).parent().text() ),
              uri: $(elt).val()};
    } );
    return $.makeArray(l);
  };

  /** Return an array of the prefixes parsed from the given query body */
  var assemblePrefixesFromQuery = function( queryBody ) {
    var leader = queryLeader( queryBody )[0].trim();
    var pairs = _.compact( leader.split( "prefix" ) );
    var prefixes = [];

    _.each( pairs, function( pair ) {
      var m = pair.match( "^\\s*(\\w+)\\s*:\\s*<([^>]*)>\\s*$" );
      prefixes.push( {name: m[1], uri: m[2]} );
    } );

    return prefixes;
  };

  /** Ensure that the prefix buttons are in sync with the prefixes used in a new query */
  var syncPrefixButtonState = function( prefixes ) {
    $("ul.prefixes a" ).each( function( i, elt ) {
      var name = $.trim( $(elt).text() );

      if (_.find( prefixes, function(p) {return p.name === name;} )) {
        $(elt).addClass( "active" );
      }
      else {
        $(elt).removeClass( "active" );
      }
    } );
  };

  /** Return the current configuration, primarily prefixes */
  var currentConfiguration = function() {
    var config = {};

    var prefixList = assembleCurrentPrefixes();
    config.prefixes = {};

    _.each( prefixList, function( pair ) {config.prefixes[pair.name] = pair.uri;} );

    return config;
  };

  /** Split a query into leader (prefixes and leading blank lines) and body */
  var queryLeader = function( query ) {
    var pattern = /(prefix [^>]+>[\s\n]*)/;
    var queryBody = query;
    var i = 0;
    var m = queryBody.match( pattern );

    while (m) {
      i += m[1].length;
      queryBody = queryBody.substring( i );
      m = queryBody.match( pattern );
    }

    return [query.substring( 0, query.length - queryBody.length), queryBody];
  };

  /** Remove the query leader */
  var stripLeader = function( query ) {
    return queryLeader( query )[1];
  };

  /** Return a string comprising the given prefixes */
  var renderPrefixes = function( prefixes ) {
    return _.map( prefixes, function( p ) {
      return Sprintf.sprintf( "prefix %s: <%s>", p.name, p.uri );
    } ).join( "\n" );
  };

  /** Add or remove the given prefix declaration from the current query */
  var updatePrefixDeclaration = function( prefix, uri, added ) {
    var query = currentQueryText();
    var lines = query.split( "\n" );
    var pattern = new RegExp( "^prefix +" + prefix + ":");
    var found = false;
    var i;

    for (i = 0; !found && i < lines.length; i++) {
      found = lines[i].match( pattern );
      if (found && !added) {
        lines.splice( i, 1 );
      }
    }

    if (!found && added) {
      for (i = 0; i < lines.length; i++) {
        if (!lines[i].match( /^prefix/ )) {
          lines.splice( i, 0, Sprintf.sprintf( "prefix %s: <%s>", prefix, uri ) );
          break;
        }
      }
    }

    setCurrentQueryText( lines.join( "\n" ) );
  };

  /** Perform the query */
  var runQuery = function( e ) {
    e.preventDefault();
    resetResults();

    var format = selectedFormat();
    var query = currentQueryText();

    var options = {
      success: function( data ) {
        onQuerySuccess( data, format );
      },
      error: onQueryFail,
      method: "post",
      data: {
        output: format,
        url: currentEndpoint(),
        q: query
      }
    };

    // sparqlService().execute( query, options );
    var formURL = $("form.qonsole").attr( "action" );
    $.ajax( formURL, options );
  };


  /** Hide or reveal an element using Bootstrap .hidden class */
  var elementVisible = function( elem, visible ) {
    if (visible) {
      $(elem).removeClass( "hidden" );
    }
    else {
      $(elem).addClass( "hidden" );
    }
  };

  /** Prepare to show query time taken */
  var startTimingResults = function() {
    _startTime = new Date().getTime();
    elementVisible( ".timeTaken" );
  };

  /** Show results count and time */
  var showResultsTimeAndCount = function( count ) {
    var duration = new Date().getTime() - _startTime;
    var ms = duration % 1000;
    duration = Math.floor( duration / 1000 );
    var s = duration % 60;
    var m = Math.floor( duration / 60 );
    var suffix = (count !== 1) ? "s" : "";

    var html = Sprintf.sprintf( "%s result%s in %d min %d.%03d s", count, suffix, m, s, ms );

    $(".timeTaken").html( html );
    elementVisible( ".timeTaken", true );
  };

  /** Reset the results display */
  var resetResults = function() {
    $("#results").empty();
    elementVisible( ".timeTaken", false );
  };

  /** Report query failure */
  var onQueryFail = function( jqXHR ) {
    var text = jqXHR.valueOf().responseText || Sprintf.sprintf( "Sorry, that didn't work because: '%s'", jqXHR.valueOf().statusText );
    renderFailure( text );
  };

  var renderFailure = function( message ) {
    showResultsTimeAndCount( 0 );
    $("#results").html( Sprintf.sprintf( "<pre class='bg-danger'>%s</pre>", _.escape(message) ) );
  };

  /** Query succeeded - use display type to determine how to render */
  var onQuerySuccess = function( data, format ) {
    if (data.status >= 200 && data.status <= 299) {
      var result = new SparqlServiceResult( data.result, format );
      var options = result.asFormat( format, currentConfiguration() );

      if (options && !options.table) {
        showCodeMirrorResult( options );
      }
      else if (options && options.table) {
        showTableResult( options );
      }
    }
    else {
      renderFailure( data.error );
    }
  };

  /** Show the given text value in a CodeMirror block with the given language mode */
  var showCodeMirrorResult = function( options ) {
    showResultsTimeAndCount( options.count );

    new CodeMirror( $("#results").get(0), {
      value: options.data,
      mode: options.mime,
      lineNumbers: true,
      extraKeys: {"Ctrl-Q": function(cm){ cm.foldCode(cm.getCursor()); }},
      gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"],
      foldGutter: true,
      readOnly: true,
      smartIndent: false
    } );
  };

  /** Show the result using jQuery dataTables */
  var showTableResult = function( options ) {
    showResultsTimeAndCount( options.count );

    $("#results").empty()
                 .append( "<div class='auto-overflow'></div>")
                 .children()
                 .append( "<table cellpadding='0' cellspacing='0' border='0' class='display'></table>" )
                 .children()
                 .dataTable( options );
  };

  /** Lookup a prefix on prefix.cc */
  var onLookupPrefix = function( e ) {
    e.preventDefault();

    var prefix = $.trim( $("#inputPrefix").val() );
    $("#inputURI").val("");

    if (prefix) {
      $.getJSON( Sprintf.sprintf( "http://prefix.cc/%s.file.json", prefix ),
                function( data ) {
                  $("#inputURI").val( data[prefix] );
                }
            );
    }
  };

  /** User wishes to add the prefix */
  var onAddPrefix = function() {
    var prefix = $.trim( $("#inputPrefix").val() );
    var uri = $.trim( $("#inputURI").val() );

    if (uri) {
      _config.prefixes[prefix] = uri;
    }
    else {
      delete _config.prefixes[prefix];
    }

    // remember the state of current user selections, then re-create the list
    var selections = {};
    $("ul.prefixes a.btn").each( function( i, a ) {selections[$(a).text()] = $(a).hasClass("active");} );

    $("ul.prefixes li[class!=keep]").remove();
    // initPrefixes( config() );

    // restore selections state
    $.each( selections, function( k, v ) {
      if (!v) {
        $(Sprintf.sprintf("ul.prefixes a.btn:contains('%s')", k)).removeClass("active");
      }
    } );

    var lines = currentQueryText().split("\n");
    lines = _.reject( lines, function( line ) {return line.match( /^prefix/ );} );
    var q = Sprintf.sprintf( "%s\n%s", renderPrefixes( assembleCurrentPrefixes() ), lines.join( "\n" ) );
    setCurrentQueryText( q );
  };

  return {
    init: init
  };
} );

