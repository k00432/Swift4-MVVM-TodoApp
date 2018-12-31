import UIKit
import os.log
class IndexView: UITableViewController {
    /*------------------------------------------------viewModel-------------------------------------------------*/
    var viewModel:IndexViewModel = IndexViewModel();
    /*------------------------------------------------funcs-----------------------------------------------------*/
    override func viewWillAppear(_ animated: Bool) {
        os_log(.info,"ItemView -> viewWillAppear func : exec")
        self.viewModel.updateTodoList();
        os_log(.info,"ItemView -> viewWillAppear func : reloadData")
        self.tableView.reloadData();
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        os_log(.info,"ItemView -> numberOfSections func : exec (section 1)")
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        os_log(.info,"ItemView -> tableView func row : exec")
        return viewModel.todoLength;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        os_log(.info,"ItemView -> tableView func UITableViewCell : exec")
        let cell = tableView.dequeueReusableCell(withIdentifier: "IndexTableCell", for: indexPath) as! IndexTableCell
        cell.id = viewModel.arrayTodo[indexPath.row].id;
        cell.textButton.text = viewModel.arrayTodo[indexPath.row].text;
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        os_log(.info,"ItemView -> tableView func edit : exec")
        if editingStyle == .delete {
            os_log(.info,"ItemView -> tableView func edit : delect button tap")
            let indexTableCell = tableView.cellForRow(at: indexPath) as! IndexTableCell;
            let id = indexTableCell.id!;
            viewModel.removeTodo(index: id,completion:{(isSucc) in
                self.viewModel.updateTodoList();
                tableView.deleteRows(at: [indexPath], with: .fade)
            })
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        os_log(.info,"ItemView -> tableView func didselect : tap item %i",indexPath.row)
        let cell = tableView.cellForRow(at: indexPath) as! IndexTableCell;
        os_log(.info,"ItemView -> tableView func didselect : performSegue editSegue exec")
        performSegue(withIdentifier: "editSegue", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        os_log(.info,"ItemView -> prepare func : exec")
        switch segue.identifier {
        case "editSegue":
            let itemview = segue.destination as! ItemView
            let cell = sender as! IndexTableCell
            os_log(.info,"ItemView -> prepare func : itemview viewModel binding (id : %i, text : %@)",cell.id!,cell.textButton.text!)
            itemview.viewModel.todo.id = cell.id!;
            itemview.viewModel.todo.text = cell.textButton.text!;
            break;
        default:
            break;
        }
    }
}
