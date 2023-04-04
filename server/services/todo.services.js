const { deleteToDo } = require("../controller/todo.controller");
const ToDoModel = require("../model/todo.model");
class ToDoService {
    static async createToDo(email, title, description, datetime) {
        const createToDo = new ToDoModel({ email, title, description, datetime });
        return await createToDo.save();
    }
    // static async EditToDo(id,title, desc){

    // }

    static async EditToDo(id, title, desc, res) {
        if (id != null && title != null && desc != null) {
            try {
                await ToDoModel.updateOne({ _id: id }, { $set: { title: title, description: desc } });
                res.status(200).json({ message: "data is updated" });
            } catch {
                res.status(404).json({ message: "something wrong!!" });
            }
        } else {
            res.status(404).json({ message: "data is emty plz write something" });
        }
    }

    static async getUserToDoList(email) {
        const todoList = await ToDoModel.find({ email });
        return todoList;
    }
    static async deleteToDo(id) {
        const deleted = await ToDoModel.findByIdAndDelete({ _id: id });
        return deleted;
    }
}
module.exports = ToDoService;
