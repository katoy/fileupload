waiting = ->

  # document.body.style.cursor="url('images/Busy.ani'),progress";
  document.body.style.cursor = "progress"
fin = ->
  document.body.style.cursor = "pointer"
$ ->

  # for list.ks
  options = valueNames: ["epub-title", "epub-creator", "epub-name"]
  epubList = new List("epub-list", options)

  # fpr tooltip, popover
  $("a[rel=tooltip]").tooltip placement: "bottom"
  $(".show-index").click ->
    $.cookie "show-index", "true",
      expires: 7

    set_index "true"

  $(".hide-index").click ->
    $.cookie "show-index", "false",
      expires: 7

    set_index "false"


  # see: https://github.com/twitter/bootstrap/issues/4803
  # modal の内容が cache されないようにする。
  $("body").on "hidden", ".modal", ->
    $(this).removeData "modal"
