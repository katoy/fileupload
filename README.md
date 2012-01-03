
Usage
=====

    $ git clone *********
    $ cd fileupload
    
    $ cake 
    
    $ cake setup clean compile
    
    $ cake epubcheck3
    //  示された手順に従って、epub3 の checker を lib/epubcheck3 に配置する。
    
    $ cake run
    or
    $ cake -p=3000 -e=production run
    
    Access http://localhost:3000/


<a href="docs/screen-00.png"><img src="docs/screen-00.png" width="230" height="170"/></a>
<a href="docs/screen-01.png"><img src="docs/screen-01.png" width="230" height="170"/></a>
<a href="docs/screen-02.png"><img src="docs/screen-02.png" width="230" height="170"/></a>
<br/>
<a href="docs/screen-03.png"><img src="docs/screen-03.png" width="230" height="170"/></a>
<a href="docs/screen-04.png"><img src="docs/screen-04.png" width="230" height="170"/></a>
<a href="docs/screen-05.png"><img src="docs/screen-05.png" width="230" height="170"/></a>
<br/>
<a href="docs/screen-06.png"><img src="docs/screen-06.png" width="230" height="170"/></a>
<a href="docs/screen-07.png"><img src="docs/screen-07.png" width="230" height="170"/></a>
<a href="docs/screen-08.png"><img src="docs/screen-08.png" width="230" height="170"/></a>
<a href="docs/screen-09.png"><img src="docs/screen-09.png" width="230" height="170"/></a>


Description
============
express + coffeescript + connect_form で　ファイルのアップロードを実装しています。
拡張子が .epub のファイルをアップロードした場合、アップロードしたファイル一覧ページから
epub としての妥当性チェックをしたり、epub 中のファイルを閲覧することができます。

TODO
====
- ファイルチューザーで複数ファイルを選択出来るようにする。
- Drag & Drop でもアップロードできるようにする。
- ファイル種類により サムネイル、ファイルアイコンを表示するようにする。

See
====
次の記事を参考にした。

- [File uploads using node.js and express](http://nodetuts.com/tutorials/12-file-uploads-using-nodejs-and-express.html)

- [version for connect-form](https://github.com/jAlpedrinha/nodetuts_ep12)

epub3 のサンプル

- [Indesign→EPUB3.0作成ワークフロー／サンプルコンテ](http://www.sanyosha.co.jp/technology/epub3workflow)

- [epubcafe](http://www.epubcafe.jp/jbasic)

- [EPUB3 コンテスト 第1回 結果発表](http://www.epubcafe.jp/egls/epubcon01a/)
  
- [epub-revision - Development area for EPUB3 - Google Project Hosting](http://code.google.com/p/epub-revision/downloads/list)

- [先週、勢いで公開した EPUB 3 の縦組サンプル](https://plus.google.com/u/0/116981871757959838886/posts/h9uzht2T9XZ#116981871757959838886/posts/h9uzht2T9XZ)

- [katokt訳・ディケンズ『クリスマス・キャロル』のEPUB3版を作ってみました](http://d.hatena.ne.jp/tatsu-zine/20111222/1324530598)



//--- End of File ---
