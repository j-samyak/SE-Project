const app = require('./app');
const db = require('./config/db');
const userModel = require('./model/user.model');
const ToDoModel = require('./model/todo.model');
require("dotenv").config();

const port = 3000;

app.get ('/',(req,res)=>{
    res.send('hello world!!!')
})

// app.listen(port,()=>{
//     console.log(`server listning on port http://localhost:${port}`);
// });

app.listen(port,'0.0.0.0',()=>{
    console.log(`server listning on port: ${port}`);
})