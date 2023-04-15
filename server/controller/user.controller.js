const UserServices = require("../services/user.services");
const { sendEmailVerificationLink, sendPasswordResetLink } = require("../config/email");
const path = require("path");

require("dotenv").config();

exports.register = async (req, res) => {
    try {
        const { name, email, contactNumber, password } = req.body;
        let present = await UserServices.checkUser(email);
        if (present) {
            if (present.verified === true) {
                return res.status(400).json({
                    status: "FAILED",
                    message: "User already exists",
                });
            } else {
                await UserServices.deleteUser(email);
            }
        }
        const newUser = await UserServices.registerUser(name, email, contactNumber, password);
        let verifyToken = await UserServices.generateToken({ id: newUser._id }, process.env.JWT_SECRET, 5 * 60 * 1000);
        let link = "http://" + req.get("host") + "/verify/" + verifyToken;
        await sendEmailVerificationLink(email, name, link);
        res.status(200).json({ status: "SUCCESS", message: "User registered successfully" });
    } catch (error) {
        console.log(error);
        return res.status(400).json({
            status: "FAILED",
            message: "Something went wrong",
        });
    }
};

exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;
        console.log(email, password);
        if (!email || !password) {
            return res.status(400).json({
                status: "FAILED",
                message: "Please enter all fields",
            });
        }

        const user = await UserServices.getUserByEmail(email);
        console.log(user);
        if (!user || user.verified === false) {
            return res.status(400).json({
                status: "FAILED",
                message: "Email has not been verified yet. Check your inbox",
            });
        }
        const ismatch = await user.comparePassword(password);
        if (ismatch === false) {
            return res.status(400).json({
                status: "FAILED",
                message: "Something went wrong",
            });
        }
        let tokendata = { _id: user._id, name: user.name, email: user.email };
        const token = await UserServices.generateToken(tokendata, process.env.JWT_SECRET, "30d");
        res.status(200).json({ status: "SUCCESS", token: token });
    } catch (error) {
        return res.status(400).json({
            status: "FAILED",
            message: "Something went wrong",
        });
    }
};

exports.verifyUser = async (req, res) => {
    let token = req.params.token;
    if (token) {
        let user = await UserServices.verifyUser(token);
        if (user.error) {
            return res.status(400).sendFile(path.join(__dirname, "../views/verificationError.html"));
        }
        return res.status(200).sendFile(path.join(__dirname, "../views/verificationSuccess.html"));
    } else {
        return res.status(400).sendFile(path.join(__dirname, "../views/error.html"));
    }
};

exports.raisePasswordChangeRequest = async (req, res) => {
    try {
        const {email} = req.body;
        if(!email || email==""){
            return res.status(400).json({
                status: "FAILED",
                message: "invalid Email",
            });
        }

        let user = await UserServices.getUserByEmail(email);
        if(!user){
            return res.status(400).json({
                status: "FAILED",
                message: "User not found",
            });
        }

        let verifyToken = await UserServices.generateToken({ id: user._id, email: user.email }, process.env.JWT_SECRET, 5 * 60 * 1000);
        let link = "http://" + req.get("host") + "/reset/" + verifyToken;
        console.log(email, link);
        await sendPasswordResetLink(email, user.name, link)
        return res.status(200).json({ status: "SUCCESS", message: "Email Sent Successfully." });
    } catch (err){
        return res.status(400).json({
            status: "FAILED",
            message: "Something went wrong",
        });
    }
}

exports.viewPasswordResetPage = async (req, res) => {
    let token = req.params.token;
    if (token) {
        let user = await UserServices.getUserByToken(token);
        if (user.error) {
            return res.status(400).sendFile(path.join(__dirname, "../views/error.html"));
        }
        return res.status(200).sendFile(path.join(__dirname, "../views/passwordReset.html"));
    } else {
        return res.status(400).sendFile(path.join(__dirname, "../views/error.html"));
    }
}

exports.verifyPasswordReset = async (req, res) => {
    let token = req.params.token;
    let {newPassword} = req.body;
    if (token) {
        let user = await UserServices.updatePassword(token, newPassword);
        if (user.error) {
            return res.status(400).sendFile(path.join(__dirname, "../views/error.html"));
        }
        return res.status(200).sendFile(path.join(__dirname, "../views/passwordResetSuccess.html"));
    } else {
        return res.status(400).sendFile(path.join(__dirname, "../views/error.html"));
    }
}

exports.gotoProfile = async(req,res,next)=>{
    try{
        console.log(req.body)
        const {email} = req.body;

        const user = await UserServices.getUserByEmail(email);
        if(!user){
            res.status(404).json({
                status: "FAILED",
                message: "Email has not been verified yet. Check your inbox",
            });
        }else{           
            res.status(200).json({status:true, data: user})
        }

    }catch(error){
        return res.status(400).json({
            status: "FAILED",
            message: "Something went wrong",
        });
    }
}

exports.updateDetails =  async (req,res)=>{
    try {
        const { name,email, contactNumber } = req.body;
        console.log(email);
        let userData = await UserServices.updateDetails(name,email, contactNumber);
        res.status(200).json({status: true,success:userData});
    } catch (error) {
        return res.status(400).json({
            status: "FAILED",
            message: "Something went wrong",
        });
    }
}

exports.checkPassword = async(req,res)=>{
    try{
        const { email, password } = req.body;
        console.log(email, password);

        const user = await UserServices.getUserByEmail(email);
        const ismatch = await user.comparePassword(password);
        if (ismatch === false) {
            return res.status(400).json({
                status: "FAILED",
                message: "Something went wrong",
            });
        }
        res.status(200).json({ status: "SUCCESS" });        
    }catch{
        return res.status(400).json({
            status: "FAILED",
            message: "Something went wrong",
        });
    }
}

exports.updatePassword = async (req,res) => {
    try {
        const {email,password } = req.body;
        console.log(email);
        let userData = await UserServices.updatePasswordByEamil(email,password);
        res.status(200).json({status: true,success:userData});
    } catch (error) {
        return res.status(400).json({
            status: "FAILED",
            message: "Something went wrong",
        });
    }
}
