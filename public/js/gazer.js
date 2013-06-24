$(document).ready(function() {
  $localsTable = $('#localsTable');

  Rainbow.onHighlight(colorRunLines);

  $(document).on('mouseover', 'tr.line td', null, function(e) {
    var lineNumber = parseInt(
      $(e.target).data('line-number') ||
      $(e.target).siblings().first().data('line-number') );
    if(!lineNumber)
      return;
    else {
      var localsData = JSON.parse ( $(e.target).parents(".invocation").
        first().children(".localsJSON").text() );
    }
    var $head = $("tr", $localsTable).first().remove();
    $localsTable.empty();
    $localsTable.append($head);
    var locals = localsData[lineNumber];
    if (!locals) return;
    locals.forEach(function(local) {
      $localsTable.append($("<tr><th>"+local[0]+"</th><td>"+local[1]+"</td></tr>"))
    });
  })
});

function colorRunLines(block, language) {
  // block.table is added by a hack to rainbow.linenumbers
  var localsData = JSON.parse ( $(block.table.parentNode.parentNode).children(".localsJSON").text() );
  Object.keys(localsData).forEach( function(ln) {
    $(".line-"+ln.toString(), block.table).addClass('runLine');
  });
}