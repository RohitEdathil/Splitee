import { Router } from "express";
import { ensureLoggedIn } from "./auth/middlewares";

// App modules
import auth from "./auth/routes";
import user from "./user/routes";
import group from "./group/routes";

const router = Router();

router.use("/auth", auth);
router.use("/user", ensureLoggedIn, user);
router.use("/group", ensureLoggedIn, group);

export default router;
