import express from "express";

import middleware from "../middleware/middlewares";
import UserController from "../controllers/UserController";
import AppExerciseController from "../controllers/AppExerciseController";
import SessionController from "../controllers/SessionController";
import UserProgramController from "../controllers/UserProgramController";
let router = express.Router();

/** CRUD + LOGIN user */
router.post("/user/add", UserController.register);
router.get("/user/:id_user", UserController.getUser)
router.put("/user/update/:id_user", UserController.updateUser);
router.delete("/user/delete/:id_user", UserController.deleteUser);
router.post("/login", UserController.login);
router.post("/logout", middleware.checkAuth, UserController.logout);
router.post("/sendCode", UserController.sendCode);
router.post("/checkCode", UserController.checkCode);
router.put("/resetPassword", UserController.resetPassword);
router.post("/checkEmail", UserController.checkEmail);

/** Read only AppExercise */
router.get("/appexercises", AppExerciseController.getAllAppExercises);
router.get("/appexercise/:id_app_exercise", AppExerciseController.getDetailAppExercise);

/**  CRUD Session */
router.get("/session/:id_session", middleware.checkAuth, SessionController.getSessionByUserAndSession)
router.get("/sessions", middleware.checkAuth, SessionController.getSessionsByUser)
router.post("/session", middleware.checkAuth, SessionController.addSession)
router.delete("/session/:id_session", middleware.checkAuth, SessionController.deleteSession)
router.put("/session/:id_session", middleware.checkAuth, SessionController.updateSession)


/** CRUD ProgramsPreview */
router.get("/programspreview", middleware.checkAuth, UserProgramController.getProgramsPreview)

export default router;