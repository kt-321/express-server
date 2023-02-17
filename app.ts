import { ethers } from "ethers"
// import { hre } from 'hardhat';

/* 1. expressモジュールをロードし、インスタンス化してappに代入。*/
import express from 'express';
var app = express();

/* 2. listen()メソッドを実行して3001番ポートで待ち受け。*/

app.listen(3001, () => console.log(`Server is running at 3001`));

/* 3. 以後、アプリケーション固有の処理 */

// 写真のサンプルデータ
var photoList = [
    {
        id: "001",
        name: "photo001.jpg",
        type: "jpg",
        dataUrl: "http://localhost:3001/data/photo001.jpg"
    },{
        id: "002",
        name: "photo002.jpg",
        type: "jpg",
        dataUrl: "http://localhost:3001/data/photo002.jpg"
    }
]

// View EngineにEJSを指定。
app.set('view engine', 'ejs');

// 写真リストを取得するAPI
app.get("/api/photo/list", function(req, res, next){
    res.json(photoList);
});
// "/"へのGETリクエストでindex.ejsを表示する。拡張子（.ejs）は省略されていることに注意。
app.get("/", function(req, res, next){
    res.render("index", {});
});

// TODO alchemy
const rpc = '';
const provider = new ethers.providers.JsonRpcProvider(rpc);
console.log("provider:", provider)
