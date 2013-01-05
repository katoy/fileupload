
function waiting() {
    // document.body.style.cursor="url('images/Busy.ani'),progress";
    document.body.style.cursor="progress";
};

function fin() {
    document.body.style.cursor='pointer';
};

$(function() {

    // for list.ks
    var options = {
        valueNames: [ 'epub-title', 'epub-creator', 'epub-name' ]
    };
    var epubList = new List('epub-list', options);

    // fpr tooltip, popover
    $('a[rel=tooltip]').tooltip();
    $('a[rel=popover]').popover();

    $("#show-index").click(function() {
      $.cookie('show-index', 'true', { expires: 7 });
      set_index("true");
    });

    $("#hide-index").click(function() {
      $.cookie('show-index', 'false', { expires: 7 });
      set_index("false");
    });

});
