//
//  TodoCacheDecorator.swift
//  RecursiveToDo
//
//  Created by macbook abdul on 27/03/2024.
//

import Foundation
import TodoShared
//decorating saving cache in loading functionality
final class TodoCacheDecorator: NSObject {
    private let decoratee: TodoManager
    private let cache: TodoCache
    
    init(decoratee: TodoManager, cache: TodoCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
}

final class TodoCacheDecoratorLoader: NSObject,TodoLoader{
    private let decoratee: TodoManager
    private let cache: TodoCache
    
    init(decoratee: TodoManager, cache: TodoCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func load(completion: (([Todo]?) -> Void)!) {
        decoratee.load { [weak self] todos in
            let todos = todos ?? []
            if !todos.isEmpty{
                self?.cache.saveIgnoringResult(todos)
            }
            completion(todos)
        }
    }
}


extension TodoCacheDecorator:TodoMover,TodoAdder,TodoStatusUpdater,TodoDeleter,TodoNameUpdater{
    func move(_ flattenArr: [Todo]!, completion: (([Todo]?) -> Void)!) {
        decoratee.move(flattenArr)  {[weak self] todos in
            self?.cache.saveIgnoringResult(todos ?? [])
            completion(todos)
        }
    }
    
    
    func updateName(_ name: String!, id: String!, completion: (([Todo]?) -> Void)!) {
        decoratee.updateName(name, id: id) { [weak self] todos in
            self?.cache.saveIgnoringResult(todos ?? [])
            completion(todos)
        }
    }
    
    
    
    func deleteNode(_ node: Todo!, completion: (([Todo]?) -> Void)!) {
        decoratee.deleteNode(node) { [weak self] todos in
            self?.cache.saveIgnoringResult(todos ?? [])
            completion(todos)
        }
    }
    
    
    
    func updateStatus(_ node: Todo!, completion: (([Todo]?) -> Void)!) {
        decoratee.updateStatus(node) { [weak self] todos in
            self?.cache.saveIgnoringResult(todos ?? [])
            completion(todos)
        }
    }
    
    
    func createNode(_ node: Todo!, completion: (([Todo]?) -> Void)!) {
        decoratee.createNode(node) { [weak self] todos in
            self?.cache.saveIgnoringResult(todos ?? [])
            completion(todos)
        }
    }
    
}
private extension TodoCache {
    func saveIgnoringResult(_ todos: [Todo]) {
        save(todos) { _ in }
    }
}
