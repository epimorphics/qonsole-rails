/** A simple interface to a remote SPARQL service */

modulejs.define( "sparql-service-result", [
  "lib/lodash",
  "lib/jquery",
  "sprintf"
],
function(
  _,
  $,
  Sprintf
) {
  "use strict";

  /** Return the string representation of the given XML value, which may be a string or a DOM object */
  var xmlToString = function( xmlData ) {
    var xs = _.isString( xmlData ) ? xmlData : null;

    if (!xs && window.ActiveXObject && xmlData.xml) {
      xs = xmlData.xml;
    }

    if (!xs) {
      xs = new XMLSerializer().serializeToString( xmlData );
    }

    return xs;
  };

  /** This class provides a duck-typed API for accessing the content of a value
   * returned from a SPARQL service. The key methods are:
   *
   * asText - returns the result as a suitably formatted text string
   * asJSON - returns the result as a suitably formatted JSON string
   * asXML - returns the result as a suitable formatted XML string
   * asTable - returns the result as an array of objects, with one key per object per query variable
   */
  var SparqlServiceResult = function( val, format ) {
    this._val = val;
    this._format = format;
  };

  _.extend( SparqlServiceResult.prototype, {
    asText: function() {
      var data = this._val;
      return {
        count: data.split("\n").length - 5,
        data: data,
        mime: "text/plain"
      };
    },

    asJSON: function() {
      var json, data = this._val;

      if (_.isString( data )) {
        json = data;
        data = JSON.parse(data);
      }
      else {
        // en bas le Internet Explorer
        json = JSON.stringify( data, null, 2 );
      }

      return {
        count: data.results.bindings.length,
        data: json,
        mime: "application/json"
      };
    },

    asXML: function() {
      var xml, data = this._val;

      if (_.isString( data )) {
        xml = data;
        data = $.parseXML( data );
      }
      else {
        xml = xmlToString( data );
      }

      return {
        count: $( data ).find("results").children().length,
        data: xml,
        mime: "application/xml"
      };
    },

    asTable: function( config ) {
      /* Shorten a URI to qname form, if possible */
      var toQName = function( prefixes, uri ) {
        var result = uri, qname, u = uri;

        if (u.substring( 0, 1 ) === "<") {
          u = u.substring( 1, u.length - 1 );
        }

        $.each( prefixes, function( prefix, prefURI ) {
          if (u.indexOf( prefURI ) === 0) {
            qname = Sprintf.sprintf( "%s:%s", prefix, u.substring( prefURI.length ) );

            if (qname.length < result.length) {
              result = qname;
            }
          }
        } );
        return result;
      };

      /** Format a value for display in the table view */
      var dataTableValue = function( v ) {
        var f, parts;

        if (_.isNumber( v )) {
          f = parseFloat( v );
        }
        else if (v.match( /\^\^/ )) {
          parts = v.match( /^"*([^\\^\\""]*)"*\^\^<*(.*)>*$/m );
          f = Sprintf.sprintf( "<span title='Type: %s'>%s</span>", parts[2], parts[1]);
        }
        else if (v.match( /@/ )) {
          parts = v.match( /^"(.*)"@([^@]*)/ );
          f = Sprintf.sprintf( "<span title='Language: %s'>%s</span>", parts[2], parts[1] );
        }
        else {
          f = toQName( config.prefixes, v );

          if (f.match( /^</ )) {
            f = f.slice( 1, -1 );
          }

          f = _.escape(f );
        }

        return f;
      };

      var data = this._val;
      var lines = _.compact(data.split( "\n" ));

      var columnHeaders = _.map( lines.shift().split("\t"), function( header) {
        return {sTitle: header.replace( /^\?/, "" )};
      } );

      var rows = _.map( lines, function( line ) {
        var values = _.flatten( [line.split("\t")] );
        return _.map( values, dataTableValue );
      } );

      return {
        count: lines.length,
        aoColumns: columnHeaders,
        aaData: rows,
        table: true
      };
    },

    asFormat: function( format, config ) {
      switch (format) {
        case "text":
          return this.asText();
        case "json":
          return this.asJSON();
        case "xml":
          return this.asXML();
        case "tsv":
          return this.asTable( config );
      }

      return null;
    }

  } );

  return SparqlServiceResult;

} );


