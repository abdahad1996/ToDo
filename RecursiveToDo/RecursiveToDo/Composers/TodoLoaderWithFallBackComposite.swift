//
//  TodoLoaderWithFallBackComposite.swift
//  RecursiveToDo
//
//  Created by macbook abdul on 27/03/2024.
//

import Foundation
import TodoShared

final class TodoLoaderSyncDecorator:NSObject,TodoLoader{
    
    private let decoratee: TodoLoader
    private let todoAdder:TodoAdder
    
    init(decoratee: TodoLoader, todoAdder: TodoAdder) {
        self.decoratee = decoratee
        self.todoAdder = todoAdder
    }
    
    func load(completion: (([Todo]?) -> Void)!) {
        decoratee.load { [weak self ] todos in
           
           let _ = todos?.map({ todo in
                self?.todoAdder.createNode(todo, completion: {_ in})
            })
            completion(todos)
        }
    }
    
    
}

final class TodoLoaderWithFallbackComposite:NSObject,TodoLoader {
    
    private let primary: TodoLoader
    private let fallback: TodoLoader
    
    init(primary: TodoLoader, fallback: TodoLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    func load(completion: (([Todo]?) -> Void)!) {
        primary.load { [weak self] todos in
            if todos?.count == 0 {
                self?.fallback.load(completion: { todos in
                    completion(todos)
                })
            }else{
                completion(todos)
            }
        }
    }
    
//    func load(completion: @escaping (UserLoader.Result) -> Void) {
//        primary.load { [weak self] result in
//            switch result {
//            case .success:
//                completion(result)
//                
//            case .failure:
//                self?.fallback.load(completion: completion)
//            }
//        }
//    }
}
