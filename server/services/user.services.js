const userModel = require("../model/user.model");
const jwt = require("jsonwebtoken");

class UserServices {
    static async registerUser(name, email, contactNumber, password) {
        const createUser = new userModel({ name, email, contactNumber, password, verified: false });
        return createUser.save();
    }

    static async verifyUser(token) {
        try {
            const decoded = jwt.verify(token, process.env.JWT_SECRET);
            return userModel.findOneAndUpdate({ _id: decoded.id }, { verified: true });
        } catch (err) {
            return { error: "Invalid token" };
        }
    }

    static async checkUser(email) {
        return userModel.exists({ email });
    }

    static async deleteUser(email) {
        return userModel.deleteOne({ email });
    }

    static async getUserByEmail(email) {
        return userModel.findOne({ email });
    }

    static async generateToken(tokendata, secretKey, jwt_expire) {
        return jwt.sign(tokendata, secretKey, { expiresIn: jwt_expire });
    }
}

module.exports = UserServices;
