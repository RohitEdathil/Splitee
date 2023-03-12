import { Router } from "express";
import { validationMiddleware } from "../error/middlewares";
import {
  createGroupController,
  editGroupController,
  inviteUserController,
  respondInviteController,
} from "./controllers";
import {
  createGroupValidator,
  editGroupValidator,
  inviteUserValidator,
  respondInviteValidator,
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

router.post(
  "/respond",
  respondInviteValidator,
  validationMiddleware,
  respondInviteController
);

export default router;
