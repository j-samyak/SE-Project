const ToDoService = require('../services/todo.services');

exports.createToDo =  async (req,res,next)=>{
    try {
        const { email,title, desc } = req.body;
        let todoData = await ToDoService.createToDo(email,title, desc);
        res.json({status: true,success:todoData});
    } catch (error) {
        console.log(error, 'err---->');
        next(error);
    }
}

exports.EditToDo =  async (req,res,next)=>{
    try {
        const { id,title, desc } = req.body;
        console.log(id);
        let todoData = await ToDoService.EditToDo(id,title, desc, res);
        // res.json({status: true,success:todoData});
    } catch (error) {
        console.log(error, 'err---->');
        next(error);
    }
}

exports.getToDoList =  async (req,res,next)=>{
    try {
        const { email } = req.body;
        console.log(email)
        let todoData = await ToDoService.getUserToDoList(email);
        res.json({status: true,success:todoData});
    } catch (error) {
        console.log(error, 'err---->');
        next(error);
    }
}

exports.deleteToDo =  async (req,res,next)=>{
    try {
        const { id } = req.body;
        let deletedData = await ToDoService.deleteToDo(id);
        res.json({status: true,success:deletedData});
    } catch (error) {
        console.log(error, 'err---->');
        next(error);
    }
}