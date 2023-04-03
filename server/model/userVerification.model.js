const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const db = require('../config/db');

const {Schema} = mongoose;

const userVerificationSchema = new Schema({
    userId:{
        type: String,
        lowercase:true
    },
    uniqueString: {
        type:String,
        lowercase:true,
        required: true,
        unique: true
    },
    createdAt:{
        type: Date,
    },
    expiresAt:{
        type: Date,
    }
    
});

userVerificationSchema.pre('save', async function(){
    try{
        var user = this;
        const salt = await(bcrypt.genSalt(10));
        const hashpass = await bcrypt.hash(user.password,salt);
        user.password = hashpass;
    }catch(error){
        throw error;
    }
});

userVerificationSchema.methods.comparePassword = async function(userPassword){
    try{
        const ismatch = await bcrypt.compare(userPassword,this.password);
        return ismatch;
    }catch(error){
        throw error;
    }
}

const userVerificationModel = db.model('userVerification',userVerificationSchema);
module.exports = userVerificationModel;