//
//  EditTodoViewModel.swift
//  Todo
//
//  Created by macbook abdul on 13/03/2024.
//

import SwiftUI
import TodoShared

class AddSubTodoViewModel:ObservableObject {
    let todoManager:TodoAdder
    let todoLoader:TodoLoader
    
    private let parent:Todo
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
    
    init(todoManager: TodoAdder, todoLoader:TodoLoader,todo:Todo) {
       self.todoManager = todoManager
       self.todoLoader = todoLoader
       self.parent = todo

   }
    
    
    func save(){
        
        self.todoLoader.load(completion: { [weak self] todos in
            guard let parentTodo = self?.parent else{return}
            //create parent
            
            let taskCount = parentTodo.children.count + 1
            let childTodo = Todo.createChildTodo(withName: self?.text ?? "", parent: parentTodo, childTaskNumber: taskCount)
//            let childTodo = Todo.createChildTodo(self?.text ?? "",parent: parentTodo, taskCount)
            self?.todoManager.createNode(childTodo) { [weak self] todos in
                guard let todos = todos else{return}
                self?.onSaveTapped?(todos)
            }
            
            
        }
        )
    }
}

