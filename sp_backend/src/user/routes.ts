import { Router } from "express";
import { validationMiddleware } from "../error/middlewares";
import {
  editUserController,
  searchUserController,
  userDataController,
} from "./controllers";
import { editUserValidator, searchUserValidator } from "./validators";

const router = Router();

router.put("/", editUserValidator, validationMiddleware, editUserController);
router.get(
  "/search",
  searchUserValidator,
  validationMiddleware,
  searchUserController
);
router.get("/:id", userDataController);

export default router;
