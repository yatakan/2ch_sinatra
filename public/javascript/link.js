$(function() {
  var number = ""
  var res = ""
  $(".text").map(function() {
    res = $(this).text().match(/>+\d{1,3}/)
    if (res) {
      number = parseInt(res[0].match(/\d{1,3}/))
      thread_id = parseInt($(this).parents('.thread').attr('id'))
      new_text = $(this).text().replace(/>+\d{1,3}/,'<a href="' + '/threads/' + thread_id + '/' + number + '"' + '>>' + number + '</a>')
        $(this).html(new_text)
    }
  });
});
