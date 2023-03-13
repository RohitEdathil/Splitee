import { Router } from "express";
import { ensureLoggedIn } from "./auth/middlewares";

// App modules
import auth from "./auth/routes";
import user from "./user/routes";
import group from "./group/routes";
import bill from "./bill/routes";

const router = Router();

router.use("/auth", auth);
router.use("/user", ensureLoggedIn, user);
router.use("/group", ensureLoggedIn, group);
router.use("/bill", ensureLoggedIn, bill);

export default router;
