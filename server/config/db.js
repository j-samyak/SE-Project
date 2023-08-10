const mongoose = require('mongoose');
require("dotenv").config();

const connection = mongoose.createConnection('proccess.env.db_link').on('open',()=>{
    console.log('mongodb connected');
}).on('error',()=>{
    console.log('mongodb connection error');
});

module.exports = connection;
