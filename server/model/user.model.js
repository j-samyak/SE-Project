const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const db = require('../config/db');
const Joi = require("joi");

const {Schema} = mongoose;

const userSchema = new Schema({
    name:{
        type: String,
        lowercase:true
    },
    email: {
        type:String,
        lowercase:true,
        required: true,
        match: [
            /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/,
            "userName format is not correct",
        ],
        unique: true
    },
    contactNumber:{
        type: String
    },
    password:{
        type:String,
        required:true
    },
    verified : {
        type : Boolean,
        default: false,
    }
});

userSchema.pre('save', async function(){
    try{
        var user = this;
        const salt = await(bcrypt.genSalt(10));
        const hashpass = await bcrypt.hash(user.password,salt);
        user.password = hashpass;
    }catch(error){
        throw error;
    }
});

userSchema.methods.comparePassword = async function(userPassword){
    try{
        const ismatch = await bcrypt.compare(userPassword,this.password);
        return ismatch;
    }catch(error){
        throw error;
    }
}


// const validate = (user) => {
//     const schema = Joi.object({
//       name: Joi.string().min(3).max(255).required(),
//       email: Joi.string().email().required(),
//     });
//     return schema.validate(user);
// };

const userModel = db.model('user',userSchema);
module.exports = userModel;
// module.exports = {userModel,validate};