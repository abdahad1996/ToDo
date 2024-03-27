//
//  TodoListViewModel.swift
//  testing_purpose
//
//  Created by macbook abdul on 12/03/2024.
//

import Foundation
import TodoShared

final public class TodoListViewModel {
    typealias Observer<T> = (T) -> Void
    
    public typealias TodoFacade = (TodoDeleter & TodoStatusUpdater)
    private let todoManager: TodoFacade
    private let todoLoader:TodoLoader
   

    public init(todoManager: TodoFacade,loader:TodoLoader) {
        self.todoManager = todoManager
        self.todoLoader = loader
    }

    var onReloadingCompleteStatusWhenSubTaskAdded:Observer<[Todo]>?
    var onUpdateName:Observer<Todo>?
    var onUpdateIsCompletedStatus: Observer<(copyTodos:[Todo],updatedTodos:[Todo])>?
    var onDeleteNode: Observer<[Todo]>?
    var onLoad: Observer<[Todo]>?


    public func loadTodo() {
        todoLoader.load { [weak self] todos in
            guard let todos = todos else{return}
            if todos.isEmpty{
                self?.onLoad?([])
                
            }else{
                // make it presentable
               let presentableTodos = PresentationHelper.flattenTodos(todos: todos)
                self?.onLoad?(presentableTodos)
                
            }
        }
    }
    
    public func loadSubTodo(copy todo:[Todo]) {
        onReloadingCompleteStatusWhenSubTaskAdded?(todo)
    }
    
    public func deleteTodo(node:Todo){
        todoManager.deleteNode(node) { [weak self] todos in
            guard let todos = todos else{return}
            let presentableTodos = PresentationHelper.flattenTodos(todos: todos)
            self?.onDeleteNode?(presentableTodos)
        }
    }
    
    public func update(copy todos:[Todo],node:Todo){
        todoManager.updateStatus(node) { [weak self] updatedTodos in
            guard let updatedTodos = updatedTodos else{return}
            let presentableTodos = PresentationHelper.flattenTodos(todos: updatedTodos)
            self?.onUpdateIsCompletedStatus?((todos,presentableTodos))
        }
    }
    
    
}
