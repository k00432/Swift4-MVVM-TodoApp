import Foundation
import os.log
class ItemViewModel{
    /*------------------------------------------------model-------------------------------------------------*/
    private var todo:Todo = Todo(id: nil,text: "", updateTime: nil,createTime: nil);
    /*------------------------------------------------servie------------------------------------------------*/
    private var dbService:SqliteDbService = SqliteDbService();
    /*------------------------------------------------funcs-------------------------------------------------*/
    func cofigure(id:Int,text:String){
        os_log(.info,"ItemViewModel -> cofigure func : exec (setting id,text)")
        self.todo.id = id;
        self.todo.text = text;
    }
    
    func getTextArea()->String{
        os_log(.info,"ItemViewModel -> getTextArea func : exec (return text)")
        return self.todo.text
    }
    
    func saveText(textArea:String,completion:@escaping (Bool)->Void){
        os_log(.info,"ItemViewModel -> saveText func : exec (save/edit text)")
        self.todo.text = textArea;
        var state = false;
        if self.todo.id == nil{
            os_log(.info,"ItemViewModel -> saveText func : (save)")
            state = dbService.insertTodo(todo:self.todo)

        }else{
            os_log(.info,"ItemViewModel -> saveText func : (edit)")
            self.todo.text = textArea;
            state = dbService.updateTodo(todo: self.todo)
        }
        os_log(.info,"ItemViewModel -> saveText func : save/edit issucc == %d ",state)
        completion(state)
    }
    
    
}
