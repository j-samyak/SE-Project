const UserServices = require("../services/user.services");
const config = require("../config/db");
const nodemailer = require("nodemailer");
// const {v4: uuidv4 } = require("uuid");
// const PasswordReset = require("../model/PasswordReset");
require("dotenv").config();

// let transporter = nodemailer.createTransport({
//     service: "gmail",
//     auth:{
//         user: process.env.AUTH_EMAIL, 
//         pass: process.env.AUTH_PASS,
//     }
// })

// transporter.verify((error, success)=>{
//     if(error){
//         console.log(error);
//     }
//     else{
//         console.log("Ready for messages");
//         console.log(success);
//     }
// })

exports.register = async(req,res,next)=>{
    try{
        console.log('hello')
        console.log(req.body)
        const {name,email,contactNumber,password} = req.body;

        // const duplicate = await UserServices.getUserByEmail(email);
        // if (duplicate) {
        //     throw new Error(`UserName ${email}, Already Registered`)
        // }

        const successRes = await UserServices.registerUser(name,email,contactNumber,password, res, transporter);
        console.log(successRes)
        // res.json({status: true, success: "user registered successfully"});
    }catch(error){
        throw error
    }
}

exports.login = async(req,res,next)=>{
    try{
        console.log(req.body)
        const {email,password} = req.body;

        if (!email || !password) {
            throw new Error('Parameter are not correct');
        }

        const user = await UserServices.checkUser(email);
        if(!user){
            throw new Error('user dont exist');
            // res.json({
            //     status: "FAILED",
            //     message: "Email has not been verified yet.Check your inbox",
            // });
        }else{
            const ismatch = await user.comparePassword(password);
            if(ismatch === false){
                throw new Error('invalid username or password');
            }
            
            let tokendata = {_id: user._id, name:user.name,email:user.email};

            const token = await UserServices.generateToken(tokendata,'####','10000h')

            res.status(200).json({status:true, token:token})
        }

    }catch(error){
        throw error
    }
}

// exports.requestPasswordReset = async(req, res) =>{
//     const{email, redirectUrl} = req.body;
//     User
//     .find({email})
//     .then((data) => {
//         if(data.length){
//             if(!data[0].verified){
//                 res.json({
//                     status: "FAILED",
//                     message: "Email hasn't been verified yet. Check your inbox",
//                 });
//             }else{
//                 sendResetEmail(data[0], redirectUrl, res);
//             }
//         }else{
//             res.json({
//                 status: "FAILED",
//                 message: "No account with the supplied email exists",
//             });
//         }
//     })
//     .catch(error=>{
//         console.log(error);
//         res.json({
//             status: "FAILED",
//             message: "An error occured while checking for existing user",
//         });
//     })
// }

// const sendResetEmail = ({_id, email}, redirectUrl, res)=>{
//     const resetString = uuidv4() + _id;
//     PasswordReset
//     .deleteMany({userId: _id})
//     .then(result=>{
//         const mailOptions = {
//             from: process.env.AUTH_EMAIL,
//             to: email,
//             subject: "Password Reset", 
//             html: `<p>Reset your password using given link</p>
//             <p>This link<b> expires in 60 minutes</b>.</p><p>Press <a href=${redirectUrl + "user/verify/" + _id + "/"+ resetString}> here</a> to proceed </p>`
                
//         };

//         const saltRounds = 10;
//         bcrypt
//         .hash(resetString, saltRounds)
//         .then((hashedResetString)=>{
//             const newPasswordReset  = new PasswordReset({
//                 userId: _id, 
//                 resetString: hashedResetString,
//                 createdAt: Date.now(), 
//                 expiresAt: Date.now() + 3600000,
//             });

//             newPasswordReset
//             .save()
//             .then(()=>{
//                 transporter
//                 .sendMail(mailOptions)
//                 .then(()=>{
//                     res.json({
//                         status: "PENDING", 
//                         message: "Password Reset email sent",
//                     });
//                 })
//                 .catch((error)=>{
//                     console.log(error);
//                     res.json({
//                         status: "FAILED", 
//                         message: "Password Reset email failed",
//                     });
//                 })
//             })
//             .catch((error)=>{
//                 console.log(error);
//                 res.json({
//                     status: "FAILED", 
//                     message: "Couldn't save Password Reset data!",
//                 });
//             })
//         })
//         .catch((error)=>{
//             console.log(error);
//             res.json({
//                 status: "FAILED", 
//                 message: "An error occured while hashing the password reset data",
//             });
//         })


//     })


//     .catch(error=>{
//         console.log(error);
//         res.json({
//             status: "FAILED",
//             message: "Clearing existing password reset records failed",
//         });
//     })
// }

// exports.resetPassword = async(req, res) =>{
//     let{userId, resetString, newPassword} = req.body;
//     PasswordReset
//     .find({userId})
//     .then(result => {
//         if(result.length>0){

//             const {expiresAt} = result[0];
//             const hashedResetString = result[0].resetString;

//             if(expiresAt < Date.now()){
//                 PasswordReset
//                 .deleteOne({userId})
//                 .then(()=>{
//                     res.json({
//                         status: "FAILED",
//                         message: "Password reset link has expired.",
//                     });
//                 })
//                 .catch(error=>{
//                     console.log(error);
//                     res.json({
//                         status: "FAILED",
//                         message: "Clearing password reset record failed.",
//                     });
//                 })
//             }
//             else{
//                 bcrypt
//                     .compare(resetString, hashedResetString)
//                     .then((result)=>{
//                         if(result){
//                             const saltRounds = 10;
//                             bcrypt
//                             .hash(newPassword, saltRounds)
//                             .then(hashedNewPassword => {

//                                 User
//                                 .updateOne({_id: userId}, {password: hashedNewPassword})
//                                 .then(()=>{
//                                     PasswordReset
//                                     .deleteOne({userId})
//                                     .then(()=>{
//                                         res.json({
//                                             status: "FAILED",
//                                             message: "Password has been reset successfully.",
//                                         })
//                                     })
//                                     .catch(error=>{
//                                         console.log(error);
//                                         res.json({
//                                             status: "FAILED",
//                                             message: "An error occured while finalizing password reset.",
//                                         })
//                                     })
//                                 })
//                                 .catch(error=>{
//                                     console.log(error);
//                                     res.json({
//                                         status: "FAILED",
//                                         message: "Updating user password failed.",
//                                     })
//                                 })

//                             })
//                             .catch(error=>{
//                                 console.log(error);
//                                 res.json({
//                                     status: "FAILED",
//                                     message: "An error occured while hashing new password.",
//                                 })
//                             })
//                         }
//                         else{
//                             res.json({
//                                 status: "FAILED",
//                                 message: "Invalid password reset details passed.",
//                             })
//                         }

//                     })
//                     .catch(error=>{
//                         console.log(error);
//                         res.json({
//                             status: "FAILED",
//                             message: "Comparing password reset string failed.",
//                         })
//                     })

//             }
//         }else{
//             res.json({
//                 status: "FAILED",
//                 message: "Password reset request not found.",
//             });
//         }
//     })
//     .catch(error=>{
//         console.log(error);
//         res.json({
//             status: "FAILED",
//             message: "Checking for existing password reset record failed.",
//         });
//     })
// }

// exports.verifyUser = (req, res)=>{
//     let{ userId, uniqueString} = req.params;

//     userVerificationModel
//     .find({userId})
//     .then((result)=>{
//         if(result.length > 0){

//             const {expiresAt} = result[0];
//             const hashedUniqueString = result[0].uniqueString;

//             if(expiresAt < Date.now()){

//                 userVerificationModel
//                 .deleteOne({userId})
//                 .then(result=>{
//                     UserServices
//                     .deleteOne({_id: userId})
//                     .then(()=>{
//                         let message = "Link has expired. Please sign up again.";
//                         res.redirect('/user/verified/error=true&message=${message}');
//                     })
//                     .catch((error)=>{
//                         console.log(error);
//                         let message = "An error occured while clearing expired user verification record";
//                         res.redirect('/user/verified/error=true&message=${message}');
//                     })
//                 })
//                 .catch((error)=>{
//                     console.log(error);
//                     let message = "An error occurred while clearing expired user verification record";
//                     res.redirect('/user/verified/erro=true&message=${message}');
//                 })
//             }
//             else{

//                 bcrypt
//                 .compare(uniqueString, hashedUniqueString)
//                 .then(result=>{
//                     if(result){

//                         UserServices
//                         .updateOne({_id: userId}, {verified: true})
//                         .then(()=>{
//                             userVerificationModel
//                             .deleteOne({userId})
//                             .then(()=>{
//                                 res.sendFile(path.join(__dirname, "./../views/verified.html"));
//                             })
//                             .catch(error=>{
//                                 console.log(error);
//                                 let message = "An error occured while finalizing successful verification.";
//                                 res.redirect('/user/verified/error=true&message=${message}');
//                             })
//                         })
//                         .catch(error=>{
//                             console.log(error);
//                             let message = "An error occured while updating user record to show verified.";
//                             res.redirect('/user/verified/error=true&message=${message}');
//                         })
//                     }else{
//                         let message = "Invalid verification details passed. check yuor inbox.";
//                         res.redirect('/user/verified/error=true&message=${message}')
//                     }
//                 })
//                 .catch(error=>{
//                     let message = "An error occured while comparing unique string.";
//                     res.redirect('/user/verified/error=true&message=${message}');
//                 })
//             }
//         }
//         else{
//             let message = "Account record doesnot exist or has been verified already. please sign up or log in.";
//             res.redirect('/user/verified/error=true&message=${message}');
//         }
//     })
//     .catch((error)=>{
//         console.log(error);
//         let message = "An error occurred while checking for existing user verification record";
//         res.redirect('/user/verified/error=true&message=${message}');
//     })
// }