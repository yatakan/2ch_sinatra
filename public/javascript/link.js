$(function() {
  var res = ""
  $(".text").map(function() {
    // 000-999
    res = $(this).text().match(/>+\d{1,3}/)
    if (res) {
      var thread_id = parseInt($(this).parents('.thread').attr('id'))
      var new_text = $(this).text().replace(/(>+)(\d{1,3})/g,'<a href="/threads/' + thread_id + '/$2">$1$2</a>')
    }
    $(this).html(new_text);
  });
});
