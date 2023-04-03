const userModel = require('../model/user.model');
// const userVerificationModel = require('../model/userVerification.model');
const jwt = require('jsonwebtoken');
// const PasswordReset = require('../model/PasswordReset');

// const sendEmail = require("../services/user.services");
const Token = require("../model/token");
const crypto = import("crypto");
const nodemailer = require("nodemailer");

class UserServices{
  static async registerUser(name,email,contactNumber,password, res, transporter){
        console.log("registerUser in user services called");
        try{
            console.log("we are in try")
            const createUser = new userModel({name,email,contactNumber,password,verified:false});
            return await createUser.save();
            // createUser
            // .save()
            // .then((result)=>{
            //     sendVerificationEmail(result, res, transporter);
            // })
            // .catch((err)=>{
            //     res.json({
            //         status: "FAILED", 
            //         message: "An error occured while saving user account",
            //     });
            // });
        }catch(err){
            throw err;
        }
  }

  static async checkUser(email){
        try{
            return await userModel.findOne({email});
        }catch(error){
            throw error;
        }
  }

  static async generateToken(tokendata,secretKey,jwt_expire){
        return jwt.sign(tokendata,secretKey,{expiresIn:jwt_expire});
  }

  static async getUserByEmail(email){
        return userModel.findOne({email});
  }
}

// const sendVerificationEmail = ({_id, email}, res, transporter) =>{
//     const currentUrl = "http://192.168.56.1:3000/";
//     const uniqueString = uuidv4() + _id;

//     const mailOptions = {
//         from: process.env.AUTH_EMAIL,
//         to: email,
//         subject: "Verify Your Email", 
//         html: `<p>Verify your email address to complete the signup and login into your account.</p>
//         <p>This link<b> expires in 5 hours</b>.</p><p>Press <a href=${currentUrl + "user/verify/" + _id + "/"+ uniqueString}> here</a> to proceed </p>`
            
//     };

//     const saltRounds = 10;
//     bcrypt
//         .hash(uniqueString, saltRounds)
//         .then((hashedUniqueString)=>{
//             const newVerification  = new userVerificationModel({
//                 userId: _id, 
//                 uniqueString: hashedUniqueString,
//                 createdAt: Date.now(), 
//                 expiresAt: Date.now() + 21600000,
//             });

//             newVerification
//             .save()
//             .then(()=>{
//                 transporter
//                 .sendMail(mailOptions)
//                 .then(()=>{
//                     res.json({
//                         status: "PENDING", 
//                         message: "Verification email sent",
//                     });
//                     console.log('sent')
//                 })
//                 .catch((error)=>{
//                     console.log(error);
//                     res.json({
//                         status: "FAILED", 
//                         message: "Verification email failed",
//                     });
//                 })
//             })
//             .catch((error)=>{
//                 console.log(error);
//                 res.json({
//                     status: "FAILED", 
//                     message: "Couldn't save verification email data!",
//                 });
//             })
//         })

//         .catch(()=>{
//             res.json({
//                 status: "FAILED", 
//                 message: "An error occured while hashing email data!",
//             });
//         })
// }



// const sendEmail = async (email, subject, text) => {
//   try {
//     const transporter = nodemailer.createTransport({
//       host: process.env.HOST,
//       service: process.env.SERVICE,
//       port: 587,
//       secure: true,
//       auth: {
//         user: process.env.USER,
//         pass: process.env.PASS,
//       },
//     });

//     await transporter.sendMail({
//       from: process.env.USER,
//       to: email,
//       subject: subject,
//       text: text,
//     });
//     console.log("email sent sucessfully");
//   } catch (error) {
//     console.log("email not sent");
//     console.log(error);
//   }
// };

// module.exports = sendEmail;

module.exports = UserServices;