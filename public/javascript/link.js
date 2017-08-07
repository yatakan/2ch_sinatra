$(function() {
  var number = ""
  var res = ""
  $(".text").map(function() {
    res = $(this).text().match(/>+\d{1,3}/)
    console.log(res)
    if (res) {
      number = parseInt(res[0].match(/\d{1,3}/))
      href = location.href.match(/\d+$/)
      new_text = $(this).text().replace(/>+\d{1,3}/,'<a href="' + '/threads/' + href + '/' + number + '"' + '>>' + number + '</a>')
      $(this).html(new_text)
    }
  });
});
