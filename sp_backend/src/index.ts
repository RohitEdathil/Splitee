import * as express from "express";
import * as dotenv from "dotenv";

dotenv.config();


const app = express()

console.log("Hello");


app.listen(process.env.PORT || 5000, () => {
    console.log(`Server is listening on port ${process.env.PORT || 5000}`)
})