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

![img1](https://github.com/k00432/Swift4-MVVM-TodoApp/blob/master/img/pigure1.png?raw=true)

### MVVM

```
- Model
  Todo.swift

- View
  IndexView.storyboard
  IndexView.swift

- ViewModel
  IndexViewModel.swift

- Service
  SqliteDbService.swift
```

### MVC

```
- Model
  Todo.swift

- View
  IndexView.storyboard

- Contoller
  IndexViewContoller.swift

- Service
  SqliteDbService.swift
```
