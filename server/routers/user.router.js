const router = require("express").Router();
const userController = require("../controller/user.controller");

const sendEmail = require("../services/user.services");
const Token = require("../model/token");
const { User, validate } = require("../model/user.model");
const crypto = import("crypto");
const nodemailer = require("nodemailer");

router.post("/registration", userController.register);
router.post("/login", userController.login);

// router.post('/requestPasswordReset',userController.requestPasswordReset);
// router.post('/resetPpassword',userController.resetPassword);
// router.get("/verify/:userId/:uniqueString", userController.verifyUser)

router.get("/verify/:token", userController.verifyUser);

module.exports = router;
