//
//  CodableTodoStore.swift
//  TodoShared
//
//  Created by macbook abdul on 26/03/2024.
//

import Foundation

public final class CodeableTodoStore: LocalStore {
    private struct Cache: Codable {
        let todos: [CodableTodos]
        
        var localCategories: [LocalTodo] {
            return todos.map { $0.toLocal() }
        }
    }
    
    public struct CodableTodos:Codable {
        var name: String
        var children: [CodableTodos]
        var level: Int
        var id: String
        var parentId: String?
        var isCompleted: Bool
        var taskNumber: String

        public init(localTodo:LocalTodo) {
            self.name = localTodo.name
            self.children = localTodo.children.map { CodableTodos(localTodo: $0) }
            self.level = localTodo.level
            self.id = localTodo.id
            self.parentId = localTodo.parentId
            self.isCompleted = localTodo.isCompleted
            self.taskNumber = localTodo.taskNumber
        }
    

        
        public func toLocal() -> LocalTodo {
                return LocalTodo(name: name,
                                 children: children.map { $0.toLocal() }, // Convert children recursively
                                 level: level,
                                 id: id,
                                 parentId: parentId,
                                 isCompleted: isCompleted,
                                 taskNumber: taskNumber)
            }
    }
    
    private let queue = DispatchQueue(label: "\(CodeableTodoStore.self)Queue", qos: .userInitiated, attributes: .concurrent)
    private let storeURL: URL
    
   public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        let storeURL = self.storeURL
        queue.async {
            guard let data = try? Data(contentsOf: storeURL) else {
                return completion(.empty)
            }
            
            do {
                let decoder = JSONDecoder()
                let cache = try decoder.decode(Cache.self, from: data)
                completion(.found(categories: cache.localCategories))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func insert(_ orders: [LocalTodo], completion: @escaping InsertionCompletion) {
        let storeURL = self.storeURL
        queue.async(flags: .barrier) {
            do {
                let encoder = JSONEncoder()
                let cache = Cache(todos: orders.map(CodableTodos.init))
                let encoded = try encoder.encode(cache)
                try encoded.write(to: storeURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func delete(completion: @escaping DeletionCompletion) {
        let storeURL = self.storeURL
        queue.async(flags: .barrier) {
            guard FileManager.default.fileExists(atPath: storeURL.path) else {
                return completion(nil)
            }
            
            do {
                try FileManager.default.removeItem(at: storeURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}
