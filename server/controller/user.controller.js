const UserServices = require("../services/user.services");
const { sendEmailVerificationLink } = require("../config/email");
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
        return res.status(400).sendFile(path.join(__dirname, "../views/verificationSuccess.html"));
    } else {
        return res.status(400).sendFile(path.join(__dirname, "../views/error.html"));
    }
};
