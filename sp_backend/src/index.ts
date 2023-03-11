import * as express from "express";
import * as dotenv from "dotenv";
import router from "./router";
import * as morgan from "morgan";
import { errorMiddleware } from "./error/middlewares";
import { initDB } from "./db";

dotenv.config();

const app = express();

initDB();

// Middlewares
app.use(express.json());
app.use(morgan(process.env.LOG_LEVEL || "dev"));

app.use("/api", router);
app.use(errorMiddleware);

app.listen(process.env.PORT || 5000, () => {
  console.log(`Server is listening on port ${process.env.PORT || 5000}`);
});
