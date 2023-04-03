const express = require("express");
const morgan = require("morgan");
const bodyParser = require("body-parser")
const UserRoute = require("./routers/user.router");
const ToDoRoute = require('./routers/todo.router');


const app = express();
app.use(morgan("dev"));
app.use(bodyParser.json())


app.use("/todo",ToDoRoute);
app.use("/",UserRoute);

module.exports = app;