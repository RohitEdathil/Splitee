import { Router } from "express";
import { validationMiddleware } from "../error/middlewares";
import { editUserController, userDataController } from "./controllers";
import { editUserValidator } from "./validators";

const router = Router();

router.get("/:id", userDataController);
router.put("/", editUserValidator, validationMiddleware, editUserController);

export default router;
