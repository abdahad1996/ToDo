//
//  EditTodoViewModel.swift
//  Todo
//
//  Created by macbook abdul on 13/03/2024.
//

import SwiftUI
import TodoShared

class AddTodoViewModel:ObservableObject {
    public typealias TodoAdderFacade = (TodoAdder & TodoLoader)

    let todoManager:TodoAdderFacade
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
    
    init(todoManager: TodoAdderFacade) {
        self.todoManager = todoManager
        
    }
    
   
    func save(){
        self.todoManager.load { [weak self] todos in
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

