(function() {
  var epub3, epub3_info, file_base, util;

  epub3 = require('./src/epub3');

  util = require('util');

  file_base = "./public/uploaded/files/alice.epub";

  epub3_info = (new epub3()).parse(file_base);

  epub3 = new epub3();

  epub3_info = epub3.parse(file_base, function(err, data) {
    var id, path, _i, _j, _len, _len2, _ref, _ref2, _results;
    if (err) throw err;
    util.log("---------------- container ------");
    util.log(util.inspect(epub3_info.container));
    util.log("---------------- opf ------");
    util.log(util.inspect(epub3_info.opf));
    util.log("---------------- ncx ------");
    util.log(util.inspect(epub3_info.ncx));
    path = epub3_info.ncx.navPoint[0].content;
    util.log(path);
    epub3.get_content(path, function(err, data) {
      if (err) throw err;
      util.log("---------------- get content ------");
      return util.log(data.substr(0, 512));
    });
    util.log("---------------- get content_ids ------");
    _ref = epub3.get_content_ids();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      id = _ref[_i];
      util.log(id);
    }
    util.log("---------------- get item_ids ------");
    _ref2 = epub3.get_item_ids();
    _results = [];
    for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
      id = _ref2[_j];
      _results.push(util.log(id));
    }
    return _results;
  });

}).call(this);
