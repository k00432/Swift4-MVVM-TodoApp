# Swift4 MVVM TodoApp

[![License](http://img.shields.io/badge/License-MIT-green.svg?style=flat)](https://github.com/clintjang/JWSBoltsSwiftSample/blob/master/LICENSE) [![Swift 4](https://img.shields.io/badge/swift-4.0-orange.svg?style=flat)](https://swift.org)

## 들어가기전에

이 프로젝트는 처음 Swift를 학습할때 작성한 프로젝트를 swift4로 구현하고 정리하기 위해 새로 작성한 프로젝트입니다.

---

### 패턴이란

프로젝트를 진행하면서 난잡할수 있는 프로그램 코드를 정리 하기위해 만든 코딩 규칙입니다.

불과 몇년 전만해도 **MVC패턴** 을 많이 사용 하였습니다.

하지만 제가 경험한 **MVC패턴** 은 프로젝트가 시간이 지나서 기능들이 많이 추가 되었을 때 **Contoller** 코드들이 난잡하게 이어지는 경우가 많았습니다.

이러한 단점을 극복하고자 여러가지 패턴에 대해 공부하게 되었고, 현재는 MVVM 패턴을 주로 사용하고있습니다.

위에서 언급했듯이 패턴은 일종의 약속 일 뿐이며 반드시 이것을 지켜야할 이유는 없습니다.

---

### MVC패턴과 MVVM패턴 비교

## ![img1](https://github.com/k00432/Swift4-MVVM-TodoApp/blob/master/img/pigure1.png?raw=true)

### Project 파일 구성

| MVVM 패턴              | MVC 패턴                   |
| ---------------------- | -------------------------- |
| **Model**              | **Model**                  |
| _Todo.swift_           | _Todo.swift_               |
| **View**               | **View**                   |
| _IndexView.storyboard_ | _IndexView.storyboard_     |
| _IndexView.swift_      |
| **ViewModel**          | **Contoller**              |
| _IndexViewModel.swift_ | _IndexViewContoller.swift_ |

---

### MVVM Sample Code

#### MVVM DataBinding Example

###### ItemViewModel.swift

```
class ItemViewModel {
    /*------------------------------------------------model-------------------------------------------------*/
    // ViewModel에서 Model 변수 선언
    var todo: Todo = Todo(id: nil, text: "", updateTime: nil, createTime: nil)
...
}
```

###### ItemView.swift

```
class ItemViewModel {
  /*------------------------------------------------view------------------------------------------------------*/
  @IBOutlet var textArea: UITextField!

...

  override func viewDidLoad() {
      os_log(.info, "ItemView -> viewDidLoad func : exec")

      // View가 그려질때 ViewModel의 Model에서 UITextField에 Binding
      textArea.text = viewModel.todo.text

      placeHolderHide()
  }

...
}
```

###### IndexView.swift

```
class ItemViewModel {
  ...

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      os_log(.info, "ItemView -> prepare func : exec")
      switch segue.identifier {
      case "editSegue":
          let itemview = segue.destination as! ItemView
          let cell = sender as! IndexTableCell
          os_log(.info, "ItemView -> prepare func : itemview viewModel binding (id : %i, text : %@)", cell.id!, cell.textButton.text!)

          // 이전 뷰의 Table View의 cell 변수를 ItemView의 Model로 Binding
          itemview.viewModel.todo.id = cell.id!
          itemview.viewModel.todo.text = cell.textButton.text!

          break
      default:
          break
      }
  }

  ...
}
```

---

#### MVVM Command Example

###### IndexView.swift

```

override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    os_log(.info, "ItemView -> tableView func edit : exec")
    if editingStyle == .delete {
        os_log(.info, "ItemView -> tableView func edit : delect button tap")

        let indexTableCell = tableView.cellForRow(at: indexPath) as! IndexTableCell
        let id = indexTableCell.id!

        // ViewModel의 removeTodo method 호출 (View -> ViewModel Command)
        viewModel.removeTodo(index: id, completion: { _ in

            // ViewModel의 removeTodo method의 콜백 호출 (ViewModel -> View Command)

            self.viewModel.updateTodoList()
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
    }
}
```

###### IndexViewModel.swift

```
func removeTodo(index: Int, completion: @escaping (Bool) -> Void) {
    os_log(.info, "IndexViewModel -> removeTodo func : exec (index == %d)", index)
    // ViewModel에서 SQLite 서비스 호출

    let state = dbService.deleteTodo(index: index)

    // 서비스 결과를 completion 콜백
    completion(state)
}
```

---

### MVC Sample Code

#### MVC Render Example

###### IndexViewContoller.swift

```
class IndexViewContoller{
  /*------------------------------------------------view------------------------------------------------------*/
  @IBOutlet var textArea: UITextField!
  /*------------------------------------------------model-------------------------------------------------*/
  var todo: Todo = Todo(id: nil, text: "", updateTime: nil, createTime: nil)

  override func viewDidLoad() {
    os_log(.info, "ItemView -> viewDidLoad func : exec")

    //Service에서 Todo Model로 Update
    todo = dbService.deleteTodo(index: index)

    // Todo Model을 이용하여 Render
    textArea.text = todo.text!


    placeHolderHide()
  }

...
}
```

---

#### MVC Request Example

###### IndexViewContoller.swift

```
class IndexViewContoller{

...

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      os_log(.info, "ItemView -> tableView func edit : exec")

      if editingStyle == .delete {
          os_log(.info, "ItemView -> tableView func edit : delect button tap")

          let indexTableCell = tableView.cellForRow(at: indexPath) as! IndexTableCell
          let id = indexTableCell.id!

          //SqliteDbService 서비스에 Delect Request (Contoller -> Service Request)
          guard dbService.deleteTodo(index: index) == false else {
              os_log(.error, "ItemView -> tableView func edit : delect serviceError")
              return
          }
      }
  }
}

...
```
