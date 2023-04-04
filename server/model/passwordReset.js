const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const db = require('../config/db');

const {Schema} = mongoose;

const PasswordResetSchema = new Schema({
    userId:{
        type: String,
        lowercase:true
    },
    resetString: {
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

PasswordResetSchema.pre('save', async function(){
    try{
        var user = this;
        const salt = await(bcrypt.genSalt(10));
        const hashpass = await bcrypt.hash(user.password,salt);
        user.password = hashpass;
    }catch(error){
        throw error;
    }
});

PasswordResetSchema.methods.comparePassword = async function(userPassword){
    try{
        const ismatch = await bcrypt.compare(userPassword,this.password);
        return ismatch;
    }catch(error){
        throw error;
    }
}

const PasswordReset = db.model('PasswordReset',PasswordResetSchema);
module.exports = PasswordReset;