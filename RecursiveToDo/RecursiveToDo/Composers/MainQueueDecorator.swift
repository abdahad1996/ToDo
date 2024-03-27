//
//  MainQueueDecorator.swift
//  RecursiveToDo
//
//  Created by macbook abdul on 27/03/2024.
//

import Foundation
import TodoShared

final class MainQueueDispatchDecorator:NSObject {
   
    private let decoratee: TodoCacheDecorator
    
    init(decoratee: TodoCacheDecorator) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        if Thread.isMainThread {
            completion()
        } else {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}

class MainQueueDispatchDecoratorTodoLoader:NSObject, TodoLoader{
    private let decoratee: TodoLoader
    
    init(decoratee: TodoLoader) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        if Thread.isMainThread {
            completion()
        } else {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func load(completion: (([Todo]?) -> Void)!) {
        decoratee.load { [weak self] todos in
            self?.dispatch {
                completion(todos)
            }
        }
    }
}
extension MainQueueDispatchDecorator:TodoMover,TodoDeleter,TodoStatusUpdater,TodoAdder,TodoNameUpdater {
    func move(_ flattenArr: [Todo]!, completion: (([Todo]?) -> Void)!) {
        decoratee.move(flattenArr) { [weak self] todos in
        self?.dispatch {
            completion(todos)
        }
    }
    }
    
    
    
    func updateName(_ name: String!, id: String!, completion: (([Todo]?) -> Void)!) {
        decoratee.updateName(name, id: id) { [weak self] todos in
                        self?.dispatch {
                            completion(todos)
                        }
                    }
    }
    
    
    
    func createNode(_ node: Todo!, completion: (([Todo]?) -> Void)!) {
        decoratee.createNode(node) { [weak self] todos in
            self?.dispatch {
                completion(todos)
            }
        }
    }
    
    func deleteNode(_ node: Todo!, completion: (([Todo]?) -> Void)!) {
        decoratee.deleteNode(node) { [weak self] todos in
            self?.dispatch {
                completion(todos)
            }
        }
    }
    
   
    func updateStatus(_ node: Todo!, completion: (([Todo]?) -> Void)!) {
        decoratee.updateStatus(node) { [weak self] todos in
            self?.dispatch {
                completion(todos)
            }
        }
    }
    
    
}

