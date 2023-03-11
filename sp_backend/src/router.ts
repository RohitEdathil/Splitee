import { Router } from "express";
import { ensureLoggedIn } from "./auth/middlewares";

// App modules
import auth from "./auth/routes";
import user from "./user/routes";

const router = Router();

router.use("/auth", auth);
router.use("/user", ensureLoggedIn, user);

export default router;
