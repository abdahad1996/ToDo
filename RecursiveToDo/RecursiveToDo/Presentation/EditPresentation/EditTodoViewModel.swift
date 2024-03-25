//
//  EditTodoViewModel.swift
//  Todo
//
//  Created by macbook abdul on 13/03/2024.
//

import SwiftUI
import Combine
import TodoShared

class EditTodoViewModel:ObservableObject {
    
    private let todoUpdater: TodoNameUpdater
    let todo:Todo
    
    @Published var isEnabled = false
    @Published var text = ""
    var onSaveTapped: (([Todo]) -> Void)?
    
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
    
    init(todoUpdater: TodoNameUpdater, todo: Todo) {
        self.todoUpdater = todoUpdater
        self.todo = todo
        text = todo.name
        $text
            .map { value in
                value.count > 0 && value != todo.name
            }
            .assign(to: &$isEnabled)
        
    }
    
    func save(){
        self.todoUpdater.updateName(text, id: todo.id) { todos in
            guard let todos = todos else{return}
            self.onSaveTapped?(todos)
        }
        
    }
}

