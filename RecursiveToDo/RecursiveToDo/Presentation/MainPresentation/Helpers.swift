//
//  Helpers.swift
//  Todo
//
//  Created by macbook abdul on 13/03/2024.
//

import Foundation
import TodoShared

final class PresentationHelper{
    // Function to flatten the array of todos
    static func flattenTodos(todos:[Todo]) -> [Todo] {
        var flattenedTodos: [Todo] = []
        for todo in todos {
            flattenedTodos.append(todo)
            flattenedTodos.append(contentsOf: flattenChildren(todo.children as! [Todo]))
        }
        return flattenedTodos
    }

    // Recursive helper function to flatten children
    static func flattenChildren(_ children: [Todo]) -> [Todo] {
        var flattenedChildren: [Todo] = []
        for child in children {
            flattenedChildren.append(child)
            flattenedChildren.append(contentsOf: flattenChildren(child.children as! [Todo]))
        }
        return flattenedChildren
    }
    
    

}


