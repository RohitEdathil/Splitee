import { Router } from "express";
import { validationMiddleware } from "../error/middlewares";
import {
  createGroupController,
  editGroupController,
  inviteUserController,
} from "./controllers";
import {
  createGroupValidator,
  editGroupValidator,
  inviteUserValidator,
} from "./validators";

const router = Router();

router.post(
  "/create",
  createGroupValidator,
  validationMiddleware,
  createGroupController
);

router.put(
  "/:id",
  editGroupValidator,
  validationMiddleware,
  editGroupController
);

router.post(
  "/invite",
  inviteUserValidator,
  validationMiddleware,
  inviteUserController
);

export default router;
