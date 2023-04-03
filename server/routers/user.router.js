const router = require('express').Router();
const userController = require("../controller/user.controller");

const sendEmail = require("../services/user.services");
const Token = require("../model/token");
const { User, validate } = require("../model/user.model");
const crypto = import("crypto");
const nodemailer = require("nodemailer");


router.post('/registration',userController.register);
router.post('/login',userController.login);


// router.post('/requestPasswordReset',userController.requestPasswordReset);
// router.post('/resetPpassword',userController.resetPassword);
// router.get("/verify/:userId/:uniqueString", userController.verifyUser)

router.post("/", async (req, res) => {
    try {
      const { error } = validate(req.body);
      if (error) return res.status(400).send(error.details[0].message);
  
      let user = await User.findOne({ email: req.body.email });
      if (user)
        return res.status(400).send("User with given email already exist!");
  
      user = await new User({
        name: req.body.name,
        email: req.body.email,
      }).save();
  
      let token = await new Token({
        userId: user._id,
        token: crypto.randomBytes(32).toString("hex"),
      }).save();
  
      const message = `${process.env.BASE_URL}/user/verify/${user.id}/${token.token}`;
      await sendEmail(user.email, "Verify Email", message);
  
      res.send("An Email sent to your account please verify");
    } catch (error) {
      res.status(400).send("An error occured");
    }
  });
  
  router.get("/verify/:id/:token", async (req, res) => {
    try {
      const user = await User.findOne({ _id: req.params.id });
      if (!user) return res.status(400).send("Invalid link");
  
      const token = await Token.findOne({
        userId: user._id,
        token: req.params.token,
      });
      if (!token) return res.status(400).send("Invalid link");
  
      await User.updateOne({ _id: user._id, verified: true });
      await Token.findByIdAndRemove(token._id);
  
      res.send("email verified sucessfully");
    } catch (error) {
      res.status(400).send("An error occured");
    }
  });

module.exports = router;