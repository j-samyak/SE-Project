const nodemailer = require("nodemailer");
require("dotenv").config();

let transporter = nodemailer.createTransport({
    // service: "gmail",
    host: "smtp.gmail.com",
    port: 587,
    auth: {
        user: process.env.AUTH_EMAIL,
        pass: process.env.AUTH_PASS,
    },
});

function sendEmailVerificationLink(email, name, verificationLink) {
    let mailOptions = {
        from: process.env.AUTH_EMAIL,
        to: email,
        subject: "Email Verification",
        html: `<h1>Hi ${name}</h1>
        <p>Please click the link below to verify your email</p>
        <a href="${verificationLink}">Click here</a>
        `,
    };

    return transporter.sendMail(mailOptions);
}

function sendPasswordResetLink(email, name, resetLink) {
    let mailOptions = {
        from: process.env.AUTH_EMAIL,
        to: email,
        subject: "Password Reset",
        html: `<h1>Hi ${name}</h1>
        <p>Please click the link below to reset your password</p>
        <a href="${resetLink}">Click here</a>
        `,
    };

    return transporter.sendMail(mailOptions);
}

module.exports = {
    sendEmailVerificationLink,
    sendPasswordResetLink,
};
