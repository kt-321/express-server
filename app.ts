import { BigNumber, ethers } from "ethers"
import hre from 'hardhat';
/* 1. expressモジュールをロードし、インスタンス化してappに代入。*/
import express from 'express';
import { Request, Response } from 'express';
import {
    // eslint-disable-next-line camelcase
    ERC20K__factory
} from './types/factories/contracts';
import { ERC20K } from './types'
import dotenv from 'dotenv';
dotenv.config()

var app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
// app.use(httpLogger);

/* 2. listen()メソッドを実行して3001番ポートで待ち受け。*/

app.listen(3001, () => console.log(`Server is running at 3001`));

const contractAddr = process.env.CONTRACT_ADDRESS || '';
const privateKey = process.env.ADMIN_WALLET_PRIVKEY_LOCAL || '';

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


const rpc = process.env.RPC_URL || '';
const provider = new ethers.providers.JsonRpcProvider(rpc);
console.log("provider:", provider)

const getSigner = async () => {
    try {
        // const signers = await hre.ethers.getSigners();
        // console.log("signers[0]:", signers[0])
        // return signers[0];

        const signer = new ethers.Wallet(privateKey, provider);
        return signer;
    } catch (error) {
        console.log("err:", error)
        // TODO
        const signers = await hre.ethers.getSigners();
        return signers[0];
    }
}

const getContractAndSigner = async() => {
    const signer = await getSigner();

    const contract = ERC20K__factory.connect(contractAddr, signer);

    return { contract, signer };
}

type MintRequest = {
    to: string;
    amount: BigNumber;
};

const mint = async(req: Request, res: Response) => {
    const request:MintRequest = req.body; // TODO
    const {contract, signer} = await getContractAndSigner();

    console.log("req.body:", req.body)

    const txRequest = await contract.populateTransaction.mint(
        request.to,
        request.amount
    )

    const receipt = await signer.sendTransaction(txRequest);

    res.send(receipt.hash);
}

const webhook =async (req: Request, res: Response) => {
    console.log(">>>webhook req:", req)
}

app.post("/mint", mint);

app.post("/webhook", webhook);

