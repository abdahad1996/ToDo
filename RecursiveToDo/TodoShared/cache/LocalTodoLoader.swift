//
//  LocalTodoLoader.swift
//  TodoShared
//
//  Created by macbook abdul on 26/03/2024.
//

import Foundation

public final class LocalTodoLoader:NSObject {
    private let store: LocalStore
    public init(store: LocalStore) {
        self.store = store
    }
}

extension LocalTodoLoader: TodoCache {
    public typealias SaveResult = Result<Void, Error>

    public func save(_ todos: [Todo], completion: @escaping (TodoCache.Result) -> Void) {
        store.delete  { [weak self] error in
                    guard let self = self else { return }
                    if let cacheDeletionError = error {
                        completion(cacheDeletionError)
                    } else {
                        self.cache(todos, with: completion)            }
                }
    }
    private func cache(_ users: [Todo], with completion: @escaping (TodoCache.Result) -> Void) {
            store.insert(users.toLocal(), completion: { [weak self] error in
                guard let _ = self else { return }
                completion(error)
            })
        }
    
}

extension LocalTodoLoader: TodoLoader {
    
    public func load(completion: (([Todo]?) -> Void)!) {
        store.retrieve { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case let .failure(error):
//                completion(.failure(error))
            print("load error:\(error)")
                completion([])
            case let .found(localUsers):
                completion(localUsers.toDomain())
                
            case .empty:
                completion([])
            }
        }
    }
    
}


private extension Array where Element == Todo {
    func toLocal() -> [LocalTodo] {
        return map { todo in
            LocalTodo(name: todo.name,
                      children: (todo.children as? [Todo] ?? []).toLocal(),
                      level: todo.level,
                      id: todo.id,
                      parentId: todo.parentId,
                      isCompleted: todo.isCompleted,
                      taskNumber: todo.taskNumber)
        }
    }
}

private extension Array where Element == LocalTodo {
    func toDomain()  -> [Todo] {
        return map { localTodo in
            Todo(name: localTodo.name,
                      children: NSMutableArray(array: localTodo.children.toDomain()),
                      level: localTodo.level,
                      id: localTodo.id,
                      parentId: localTodo.parentId,
                      isCompleted: localTodo.isCompleted,
                      taskNumber: localTodo.taskNumber)
        }
    }
}
