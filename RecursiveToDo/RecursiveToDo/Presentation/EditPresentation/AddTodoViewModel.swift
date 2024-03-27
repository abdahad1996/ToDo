//
//  EditTodoViewModel.swift
//  Todo
//
//  Created by macbook abdul on 13/03/2024.
//

import SwiftUI
import TodoShared

class AddTodoViewModel:ObservableObject {
     

    let todoManager:TodoAdder
    let todoLoader:TodoLoader
    var onSaveTapped: (([Todo]) -> Void)?

    @Published var isEnabled = false
    @Published var text = ""
    
    
    var title:String{
        "Title"
    }
    var placeholder:String{
        "Enter Title"
    }
    
    var cancel:String{
        "Cancel"
    }
    var saveTitle:String{
        "Save"
    }
    
    init(todoManager: TodoAdder, todoLoader:TodoLoader) {
       self.todoManager = todoManager
       self.todoLoader = todoLoader
       
   }
   
    
   
    func save(){
        self.todoLoader.load { [weak self] todos in
            guard let todos = todos else {return}
                //create parent
                let taskCount = todos.count + 1
                let note = Todo.createRootTodo(withName: self?.text ?? "", rootTaskNumber: taskCount)
                self?.todoManager.createNode(note) { [weak self] todos in
                    guard let todos = todos else{return}
                    self?.onSaveTapped?(todos)
                }
            
            
        }
        
    }
}

