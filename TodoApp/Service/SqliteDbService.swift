import Foundation
import SQLite3
import os.log

class SqliteDbService{
    
    var db:OpaquePointer?;
    
    init() {
        self.db = openDatabase();
        if isNotExistTable() == true {
            guard createTable() else{
                os_log(.error,"SqliteDbService -> init func : sqlite create fail")
                return
            }
        }
    }
    
    func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("TodoApp.db")
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            os_log(.info,"SqliteDbService -> openDatabase func : Success open db at %@",fileURL.path)
            return db;
        } else {
            os_log(.error,"SqliteDbService -> openDatabase func : Success fail db at %@",fileURL.path)
            return db;
        }
    }
    func isNotExistTable() -> Bool {
        os_log(.info,"SqliteDbService -> isNotExistTable func : exec")
        var tableStatement:OpaquePointer? = nil;
        let statementStr =
        """
        select case when tbl_name = 'TODOLIST'
        then 0
        else 1
        end as 'isNotExistTable'
        from sqlite_master
            where
            type = 'table' and tbl_name = 'TODOLIST'
        collate nocase;
        """
        if sqlite3_prepare_v2(db, statementStr, -1, &tableStatement,nil ) == SQLITE_OK{
            os_log(.info,"SqliteDbService -> isNotExistTable func : sqlite3_prepare == SQLITE_OK")
            if sqlite3_step(tableStatement) == SQLITE_ROW {
                os_log(.info,"SqliteDbService -> isNotExistTable func : sqlite3_prepare == SQLITE_ROW")
                if sqlite3_column_int(tableStatement, 0) == 1{
                    os_log(.info,"SqliteDbService -> isNotExistTable func : true (table is not Exist)")
                    sqlite3_finalize(tableStatement)
                    return true;
                } else{
                    os_log(.info,"SqliteDbService -> isNotExistTable func : false (table is not Exist)")
                    sqlite3_finalize(tableStatement)
                    return false;
                }
            }
        }
        os_log(.error,"SqliteDbService -> isNotExistTable func : dbfile init ")
        sqlite3_finalize(tableStatement)
        return true;
    }
    func createTable()->Bool{
        os_log(.info,"SqliteDbService -> createTable func : exec")
        let statementStr =
        """
        CREATE TABLE `TODOLIST` (
        `id`    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
        `text`    TEXT,
        `updateDate`    DATETIME,
        `createDate`    DATETIME DEFAULT CURRENT_TIMESTAMP
        );
        """
        if sqlite3_exec(db, statementStr, nil, nil, nil) == SQLITE_OK{
            os_log(.info,"SqliteDbService -> createTable func : sqlite3_exec == SQLITE_OK")
            guard isNotExistTable() == false else{
                os_log(.error,"SqliteDbService -> createTable func : verify fail")
                return false
            }
            os_log(.info,"SqliteDbService -> createTable func : succ")
            return true
        }
        os_log(.error,"SqliteDbService -> createTable func : unkown error")
        return false
    }
    
    func insertTodo(todo: Todo) -> Bool {
        os_log(.info,"SqliteDbService -> insertTodo func : exec")
        var insertStatement:OpaquePointer? = nil;
        let statementStr =
        """
        insert into 'TODOLIST'(text)
        values (?)
        """
        if sqlite3_prepare_v2(db, statementStr, -1, &insertStatement,nil ) == SQLITE_OK{
            os_log(.info,"SqliteDbService -> insertTodo func : sqlite3_prepare == SQLITE_OK")
            os_log(.info,"SqliteDbService -> insertTodo func : text == %@",todo.text)
            let cStringUtf8Text = todo.text.cString(using: String.Encoding.utf8);
            sqlite3_bind_text(insertStatement, 1, cStringUtf8Text, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                os_log(.info,"SqliteDbService -> insertTodo func : sqlite3_step == SQLITE_DONE")
                os_log(.info,"SqliteDbService -> insertTodo func : true (insert success)")
                sqlite3_finalize(insertStatement)
                return true;
            }else{
                let err =  String.init(cString: sqlite3_errmsg(db))
                os_log(.error,"SqliteDbService -> insertTodo : err = %@",err)
            }
        }
        os_log(.error,"SqliteDbService -> insertTodo : fail")
        sqlite3_finalize(insertStatement)
        return true;
    }
    
    func getTodoLength() -> Int {
        os_log(.info,"SqliteDbService -> getTodoLength func exec")
        
        var tableStatement:OpaquePointer? = nil;
        let statementStr =
        """
        select count(*) as count from 'TODOLIST'
        """
        if sqlite3_prepare_v2(db, statementStr, -1, &tableStatement,nil ) == SQLITE_OK{
            os_log(.info,"SqliteDbService -> getTodoLength func : sqlite3_prepare == SQLITE_OK")
            if sqlite3_step(tableStatement) == SQLITE_ROW {
                os_log(.info,"SqliteDbService -> getTodoLength func : sqlite3_step == SQLITE_ROW")
                let length = Int(sqlite3_column_int(tableStatement, 0))
                sqlite3_finalize(tableStatement)
                return length
            }
        }
        os_log(.error,"SqliteDbService -> getTodoLength func : sqlite3_prepare == error (table length count fail)")
        sqlite3_finalize(tableStatement)
        return -1;
    }
    
    func getTodoList() -> Array<Todo> {
        os_log(.info,"SqliteDbService -> getTodoList func exec")
        
        var tableStatement:OpaquePointer? = nil;
        let statementStr =
        """
        select id,text,strftime('%s',updateDate)as updateDate,strftime('%s',createDate)as createDate
        from TODOLIST
        order by createDate
        """
        var todoArray:Array<Todo> = [];
        if sqlite3_prepare_v2(db, statementStr, -1, &tableStatement,nil ) == SQLITE_OK{
            os_log(.info,"SqliteDbService -> getTodoList func : sqlite3_prepare == SQLITE_OK")
            while sqlite3_step(tableStatement) == SQLITE_ROW{
                os_log(.info,"SqliteDbService -> getTodoList func : sqlite3_step == SQLITE_ROW")
                let id = Int(sqlite3_column_int(tableStatement, 0));
                let text = String(cString: sqlite3_column_text(tableStatement, 1));
                let updateTime:Date = Date(timeIntervalSince1970: sqlite3_column_double(tableStatement, 2));
                let createTime:Date = Date(timeIntervalSince1970: sqlite3_column_double(tableStatement, 3));
                os_log(.info,"SqliteDbService -> getTodoList func : id == %i, text == %@, utime == %@, ctime == %@,",id,text,updateTime.description,createTime.description)
                let todo:Todo = Todo(id: id, text: text, updateTime: updateTime, createTime: createTime);
                todoArray.append(todo)
            }
            os_log(.info,"SqliteDbService -> getTodoList func : succ")
            sqlite3_finalize(tableStatement)
            return todoArray
        }
        os_log(.error,"SqliteDbService -> getTodoList func : sqlite3_prepare == error")
        sqlite3_finalize(tableStatement)
        return todoArray

    }
    
    func updateTodo(todo: Todo) -> Bool {
        os_log(.info,"SqliteDbService -> updateTodo func : exec")
        var updateStatement:OpaquePointer? = nil;
        let statementStr =
        """
        update TODOLIST set text = ?, updateDate = current_timestamp  where id = ?
        """
        if sqlite3_prepare_v2(db, statementStr, -1, &updateStatement, nil) == SQLITE_OK{
            os_log(.info,"SqliteDbService -> updateTodo func : sqlite3_prepare == SQLITE_OK")
            let cStringUtf8Text = todo.text.cString(using: String.Encoding.utf8);
            sqlite3_bind_text(updateStatement, 1, cStringUtf8Text, -1, nil);
            sqlite3_bind_int(updateStatement, 2 , Int32(todo.id!))
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                os_log(.info,"SqliteDbService -> updateTodo func : sqlite3_step == SQLITE_DONE")
                return true
            }
            os_log(.error,"SqliteDbService -> updateTodo func : sqlite3_step == error")
            return false
        }
        os_log(.error,"SqliteDbService -> updateTodo func : sqlite3_prepare == error")
        return false;
    }
    
    func deleteTodo(index:Int) -> Bool {
        os_log(.info,"SqliteDbService -> deleteTodo func : exec")
        var updateStatement:OpaquePointer? = nil;
        let statementStr =
        """
        delete from TODOLIST where id = ?
        """
        if sqlite3_prepare_v2(db, statementStr, -1, &updateStatement, nil) == SQLITE_OK{
            os_log(.info,"SqliteDbService -> deleteTodo func : sqlite3_prepare == SQLITE_OK")
            sqlite3_bind_int(updateStatement, 1 , Int32(index))
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                os_log(.info,"SqliteDbService -> deleteTodo func : sqlite3_step == SQLITE_DONE")
                return true
            }
            os_log(.error,"SqliteDbService -> deleteTodo func : sqlite3_step == error")
            return false
        }
        os_log(.error,"SqliteDbService -> deleteTodo func : sqlite3_prepare == error")
        return false;
    }
    
}
