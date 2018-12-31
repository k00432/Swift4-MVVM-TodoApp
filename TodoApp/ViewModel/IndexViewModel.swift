import Foundation
import os.log
class IndexViewModel{
    /*------------------------------------------------model-------------------------------------------------*/
    var arrayTodo:[Todo] = [Todo]();
    var todoLength:Int = 0;
    /*------------------------------------------------servie------------------------------------------------*/
    var dbService:SqliteDbService=SqliteDbService();
    /*------------------------------------------------funcs-------------------------------------------------*/

    func removeTodo(index:Int,completion:@escaping (Bool)->Void){
        os_log(.info,"IndexViewModel -> removeTodo func : exec (index == %d)",index)
        let state = dbService.deleteTodo(index: index)
        completion(state)
    }
    func updateTodoList(){
        os_log(.info,"IndexViewModel -> updateTodoList func : exec")
        self.todoLength = dbService.getTodoLength();
        self.arrayTodo = dbService.getTodoList();
    }
    
}
