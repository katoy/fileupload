
tarvis : [![Build Status](https://travis-ci.org/katoy/fileupload.png?branch=master)](https://travis-ci.org/katoy/fileupload) [![Greenkeeper badge](https://badges.greenkeeper.io/katoy/fileupload.svg)](https://greenkeeper.io/)

Usage
=====

    $ git clone https://github.com/katoy/fileupload.git
    $ cd fileupload
    
    $ npm install -g express
    $ npm install -g jasmine-node
    $ npm install -g vows

    $ bundle install
	
    $ cake 
    
    $ cake setup 
    $ cake clean
    $ cake compile
    
    $ cake epubcheck3
    //  示された手順に従って、epub3 の checker を lib/epubcheck3 に配置する。

    $ npm start
    or    
    $ cake run
    or    
    $ cake -p 3000 -e production run
    
    Access http://localhost:3000/

    $ cake test
    // vows と zombie  で brouser からのアクセスでテストを行い、coverge計測も行う。


<a href="https://github.com/katoy/fileupload/raw/master/docs/screen-00.png"><img src="https://github.com/katoy/fileupload/raw/master/docs/screen-00.png" width="230" height="170"/></a>
<a href="https://github.com/katoy/fileupload/raw/master/docs/screen-01.png"><img src="https://github.com/katoy/fileupload/raw/master/docs/screen-01.png" width="230" height="170"/></a>
<a href="https://github.com/katoy/fileupload/raw/master/docs/screen-02.png"><img src="https://github.com/katoy/fileupload/raw/master/docs/screen-02.png" width="230" height="170"/></a>
<br/>
<a href="https://github.com/katoy/fileupload/raw/master/docs/screen-03.png"><img src="https://github.com/katoy/fileupload/raw/master/docs/screen-03.png" width="230" height="170"/></a>
<a href="https://github.com/katoy/fileupload/raw/master/docs/screen-04.png"><img src="https://github.com/katoy/fileupload/raw/master/docs/screen-04.png" width="230" height="170"/></a>
<a href="https://github.com/katoy/fileupload/raw/master/docs/screen-05.png"><img src="https://github.com/katoy/fileupload/raw/master/docs/screen-05.png" width="230" height="170"/></a>
<br/>
<a href="https://github.com/katoy/fileupload/raw/master/docs/screen-06.png"><img src="https://github.com/katoy/fileupload/raw/master/docs/screen-06.png" width="230" height="170"/></a>
<a href="https://github.com/katoy/fileupload/raw/master/docs/screen-07.png"><img src="https://github.com/katoy/fileupload/raw/master/docs/screen-07.png" width="230" height="170"/></a>
<br/>
<a href="https://github.com/katoy/fileupload/raw/master/docs/screen-08.png"><img src="https://github.com/katoy/fileupload/raw/master/docs/screen-08.png" width="230" height="170"/></a>
<a href="https://github.com/katoy/fileupload/raw/master/docs/screen-09.png"><img src="https://github.com/katoy/fileupload/raw/master/docs/screen-09.png" width="230" height="170"/></a>


Description
============
express + coffeescript + connect_form で　ファイルのアップロードを実装しています。
拡張子が .epub のファイルをアップロードした場合、アップロードしたファイル一覧ページから
epub としての妥当性チェックをしたり、epub 中のファイルを閲覧することができます。


mobi ファイルを扱う場合は ebook-convert をインストールする必要があります。  
ebook-convert: [http://manual.calibre-ebook.com/cli/ebook-convert.html#](http://manual.calibre-ebook.com/cli/ebook-convert.html#)  
これは [calibre](http://calibre-ebook.com/) のコマンドラインツールです。   
[ここ](http://manual.calibre-ebook.com/cli/cli-index.html) を参照してインストールしてください。  

epub, movi, chm のファイル名に日本語が含まれている場合、express の middleware に patch を当てる必要があります。  

 ```diff
ntsitm229197:middleware youichikato$ pwd
/Users/youichikato/github/fileupload/node_modules/express/node_modules/connect/lib/middleware
ntsitm229197:middleware youichikato$ diff -c directory.js~ directory.js
*** directory.js~	2012-11-10 01:31:28.000000000 +0900
--- directory.js	2013-02-10 00:49:14.000000000 +0900
***************
*** 117,123 ****
          .replace('{files}', html(files, dir, icons))
          .replace('{directory}', dir)
          .replace('{linked-path}', htmlPath(dir));
!       res.setHeader('Content-Type', 'text/html');
        res.setHeader('Content-Length', str.length);
        res.end(str);
      });
--- 117,123 ----
          .replace('{files}', html(files, dir, icons))
          .replace('{directory}', dir)
          .replace('{linked-path}', htmlPath(dir));
!       res.setHeader('Content-Type', 'text/html; charset=UTF-8');
        res.setHeader('Content-Length', str.length);
        res.end(str);
      });
 ```

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

epub2 のサンプル

- [源氏物語 01 桐壺 - 青空文庫 - ePub形式で青空文庫を配信](http://aozora.wook.jp/detail.html?id=211949)

- [Top 100 - Project Gutenberg](http://www.gutenberg.org/browse/scores/top)

//--- End of File ---
