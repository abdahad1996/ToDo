//
//  Helpers.swift
//  TodoSharedTests
//
//  Created by macbook abdul on 14/03/2024.
//

import Foundation
import XCTest
import TodoShared

 func makeRootTodo(_ name:String,taskNumber:Int = 1)->Todo{
    return Todo.createRootTodo(withName: "abdul", rootTaskNumber: taskNumber)
}

 func makeChildTodo(_ name:String,parent todo:Todo)->Todo{
    let taskCount = todo.children.count + 1
    return Todo.createChildTodo(withName: name, parent: todo, childTaskNumber: 1)
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
