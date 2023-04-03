const mongoose = require('mongoose');


const connection = mongoose.createConnection('mongodb+srv://j_samyak:jsam1409@user.yhwosk7.mongodb.net/?retryWrites=true&w=majority').on('open',()=>{
    console.log('mongodb connected');
}).on('error',()=>{
    console.log('mongodb connection error');
});

module.exports = connection;