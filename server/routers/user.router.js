const router = require("express").Router();
const userController = require("../controller/user.controller");

router.post("/registration", userController.register);
router.post("/login", userController.login);

router.get("/verify/:token", userController.verifyUser);

router.post('/requestPasswordReset', userController.raisePasswordChangeRequest);
router.get('/reset/:token', userController.viewPasswordResetPage);
router.post('/reset/:token', userController.verifyPasswordReset);

router.post('/gotoProfile',userController.gotoProfile);
router.post('/updateDetails',userController.updateDetails);
router.post('/checkPassword',userController.checkPassword);
router.post('/updatePassword',userController.updatePassword);


module.exports = router;
