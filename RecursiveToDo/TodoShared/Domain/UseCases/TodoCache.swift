//
//  TodoCache.swift
//  TodoShared
//
//  Created by macbook abdul on 26/03/2024.
//

import Foundation

public protocol TodoCache {
    typealias Result = Error?
    func save(_ todos: [Todo], completion: @escaping (Result) -> Void)
}
