//
//  IndexPath+Helper.swift
//  Todo
//
//  Created by macbook abdul on 14/03/2024.
//

import Foundation
import TodoShared

extension Todo {
    static func indexesOfDeletedTodos(original: [Todo], updated: [Todo]) -> [Int] {
        let deletedIndexes = original.enumerated().compactMap { (index, originalTodo) in
            return updated.contains(originalTodo) ? nil : index
        }
        return deletedIndexes
    }
    
    static func indexesOfAddedTodos(original: [Todo], updated: [Todo]) -> [Int] {
        var changes: [Int] = []
        for (toIndex, element) in updated.enumerated() {
            
            if !original.contains(where: { $0.id == element.id }) {
                changes.append(toIndex)
            }
            
        }
        return changes
    }
    
    static func indexesOfChangedIsCompleted(original: [Todo], updated: [Todo]) -> [Int] {
        var changes: [Int] = []
        for (toIndex, element) in updated.enumerated() {
            
            if original.contains(where: { $0.id == element.id && $0.isCompleted != element.isCompleted }) {
                
                changes.append(toIndex)
            }
            
        }
        return changes
    }
}
