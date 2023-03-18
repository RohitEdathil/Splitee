import { Router } from "express";
import { validationMiddleware } from "../error/middlewares";
import {
  createGroupController,
  editGroupController,
  getGroupDataController,
  joinGroupController,
  leaveGroupController,
  redistributeController,
} from "./controllers";
import {
  createGroupValidator,
  editGroupValidator,
  getGroupDataValidator,
  joinGroupValidator,
  redistributeValidator,
} from "./validators";

const router = Router();

router.get(
  "/:id",
  getGroupDataValidator,
  validationMiddleware,
  getGroupDataController
);

router.get(
  "/redis/:groupId",
  redistributeValidator,
  validationMiddleware,
  redistributeController
);

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
  "/join",
  joinGroupValidator,
  validationMiddleware,
  joinGroupController
);

router.post(
  "/leave",
  joinGroupValidator,
  validationMiddleware,
  leaveGroupController
);

export default router;
