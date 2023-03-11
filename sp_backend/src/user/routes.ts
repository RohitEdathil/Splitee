import { Router } from "express";
import { userDataController } from "./controllers";

const router = Router();

router.get("/:id", userDataController);

export default router;
