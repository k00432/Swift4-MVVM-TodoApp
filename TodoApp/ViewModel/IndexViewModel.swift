import Foundation
import os.log
class IndexViewModel{
    /*------------------------------------------------model-------------------------------------------------*/
    private var arrayTodo:[Todo] = [Todo]();
    private var todoLength:Int = 0;
    /*------------------------------------------------servie------------------------------------------------*/
    var dbService:SqliteDbService=SqliteDbService();
    /*------------------------------------------------funcs-------------------------------------------------*/
    func getTodoLength() -> Int{
        os_log(.info,"IndexViewModel -> getTodoLength func : exec")
        return todoLength;
    }

    func getTodo(index:Int) -> (Int,String){
        os_log(.info,"IndexViewModel -> getTodo func : exec (index == %d)",index)
        return (arrayTodo[index].id!,arrayTodo[index].text)
    }
    func removeTodo(index:Int) -> Bool{
        os_log(.info,"IndexViewModel -> removeTodo func : exec (index == %d)",index)
        return dbService.deleteTodo(index: index)
    }
    func getTodoList(){
        os_log(.info,"IndexViewModel -> updateTodoList func : exec")
        self.todoLength = dbService.getTodoLength();
        self.arrayTodo = dbService.getTodoList();
    }
    
}
