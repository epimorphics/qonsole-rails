document.addEventListener('DOMContentLoaded', function () {
  var wrapper = document.getElementById('query-edit-cm');
  var selectEndpointButton = document.getElementById('endpointSelector');
  var instructions = document.getElementById('query-editor-desc');

  if (!wrapper) return;

  wrapper.addEventListener('keydown', function (event) {
    if (event.key === 'Escape') {
      event.preventDefault();

      var input = wrapper.querySelector('textarea');
      if (input) {
        input.blur();
      } else {
        var scroll = wrapper.querySelector('.CodeMirror-scroll');
        if (scroll) scroll.blur();
      }

      selectEndpointButton?.focus();
      return;
    }

    if (event.key === 'Tab' && event.shiftKey) {
      event.preventDefault();

      var input = wrapper.querySelector('textarea');
      if (input) {
        input.blur();
      } else {
        var scroll = wrapper.querySelector('.CodeMirror-scroll');
        if (scroll) scroll.blur();
      }

      instructions?.focus();
      return;
    }
  });
});
