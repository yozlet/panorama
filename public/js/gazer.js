$(document).ready(function() {
  $localsTable = $('#localsTable');

  //colorRunLines();

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

function colorRunLines() {
  $(".invocation").each(function(el) {
    var localsText = $(el).children(".localsJSON").text();
    if (!localsText) return;
    var localsData = JSON.parse (localsText);
    var codeBlock = $(el).children("pre").first();
    localsData.keys().foreach( function(ln) {
      $(".line-"+ln.toString(), codeBlock).addClass('runLine');
    });
  })
}