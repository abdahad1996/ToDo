//
//  EditTodoViewModel.swift
//  Todo
//
//  Created by macbook abdul on 13/03/2024.
//

import SwiftUI
import TodoShared

class AddSubTodoViewModel:ObservableObject {
    public typealias TodoAdderFacade = (TodoAdder & TodoLoader)
    private let todoManager: TodoAdderFacade
    
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
    
    init(todoManager:TodoAdderFacade,todo:Todo) {
        self.todoManager = todoManager
        self.parent = todo
        
    }
    
    
    func save(){
        
        self.todoManager.load(completion: { [weak self] todos in
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

