//
//  LocalStore.swift
//  TodoShared
//
//  Created by macbook abdul on 26/03/2024.
//

import Foundation
public enum RetrieveCachedUserResult {
    case empty
    case found(categories: [LocalTodo])
    case failure(Error)
}

public protocol LocalStore {
    
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrieveCachedUserResult) -> Void
    
    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to approprate threads, if needed.
    func delete(completion: @escaping DeletionCompletion)
    
    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to approprate threads, if needed.
    func insert(_ orders: [LocalTodo], completion: @escaping InsertionCompletion)
    
    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to approprate threads, if needed.
    func retrieve(completion: @escaping RetrievalCompletion)
    
}
