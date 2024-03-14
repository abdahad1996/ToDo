//
//  Helpers.swift
//  TodoSharedTests
//
//  Created by macbook abdul on 14/03/2024.
//

import Foundation
import XCTest
import TodoShared

public extension XCTestCase {
    
     func trackMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leaks.", file: file, line: line)
        }
    }
    
}

 func makeRootTodo(_ name:String,taskNumber:Int = 1)->Todo{
    return Todo.createRootTodo(withName: "abdul", rootTaskNumber: taskNumber)
}

 func makeChildTodo(_ name:String,parent todo:Todo)->Todo{
    let taskCount = todo.children.count + 1
    return Todo.createChildTodo(withName: name, parent: todo, childTaskNumber: taskCount+1)
}

 func getTodoParent(todo:[Todo]?,for parent:Int = 0) -> Todo {
    return todo![parent]
}
 func getToDoChild(todo:[Todo]?,for parent:Int = 0,with child:Int = 0) -> Todo {
    return todo![parent].children[child] as! Todo
}

 func getToDoSubChild(todo:[Todo]?,for parent:Int = 0,with child:Int = 0,with subChild:Int = 0) -> Todo {
    let child = todo![parent].children[child] as! Todo
    return child.children[subChild] as! Todo
    
}

func createHeirchialTodos() -> (Todo, Todo, Todo, Todo) {
    let todo1 = makeRootTodo("Task 1")
    let childTodo1 = makeChildTodo("Task 1.1", parent: todo1)
    let subChildTodo1 = makeChildTodo("Task 1.1.1", parent: childTodo1)
    let subSubChildTodo1 = makeChildTodo("Task 1.1.1.1", parent: subChildTodo1)
    return (todo1, childTodo1, subChildTodo1, subSubChildTodo1)
}

func createRootTodos() -> (Todo, Todo, Todo) {
    let task1 = makeRootTodo("Task 1")
    let task2 = makeRootTodo("Task 2")
    let task3 = makeRootTodo("Task 3")

    return (task1, task2, task3)
}
