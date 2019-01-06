import Foundation
class Todo {
    var id:Int?;
    var text:String;
    var updateTime:Date?;
    var createTime:Date?;
    init(id:Int?,text:String,updateTime:Date?,createTime:Date?) {
        self.id=id;
        self.text=text;
        self.updateTime = updateTime;
        self.createTime = createTime;
    }

}
