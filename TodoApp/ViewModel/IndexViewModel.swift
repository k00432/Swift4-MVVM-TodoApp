import Foundation
import os.log
class IndexViewModel{
    /*------------------------------------------------model-------------------------------------------------*/
    var arrayTodo:[Todo] = [Todo]();
    var todoLength:Int = 0;
    /*------------------------------------------------servie------------------------------------------------*/
    var dbService:SqliteDbService=SqliteDbService();
    /*------------------------------------------------funcs-------------------------------------------------*/

    func removeTodo(index:Int) -> Bool{
        os_log(.info,"IndexViewModel -> removeTodo func : exec (index == %d)",index)
        return dbService.deleteTodo(index: index)
    }
    func updateTodoList(){
        os_log(.info,"IndexViewModel -> updateTodoList func : exec")
        self.todoLength = dbService.getTodoLength();
        self.arrayTodo = dbService.getTodoList();
    }
    
}
