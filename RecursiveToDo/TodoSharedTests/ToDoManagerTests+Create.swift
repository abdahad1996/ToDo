//
//  ToDoManagerTests.swift
//  TodoSharedTests
//
//  Created by macbook abdul on 14/03/2024.
//

import Foundation
import XCTest
import TodoShared

class ToDoManager: XCTestCase {
    
    func test_create_RootTodo() {
        
         //Arrange
        let todoManager = makeSUT()
        let newTodo = makeRootTodo("abdul", taskNumber: 1)
        // Act
//        todo
        todoManager.createNode(newTodo) { (todos:[Todo]?) in
            XCTAssertNotNil(todos)
            XCTAssertEqual(todos?.first?.id, newTodo.id)
            XCTAssertEqual(todos?.first?.titleLabel(), "Root 1 - abdul")
            XCTAssertEqual(todos?.first?.level , 0)
            XCTAssertEqual(todos?.first?.isCompleted , false)

            XCTAssertEqual(todoManager.flattenTodos().count, 1)
        }

    }
    
    func test_create_ChildTodo() throws {
            // Arrange
            let todoManager = makeSUT()
            let rootTodo = makeRootTodo("Parent", taskNumber: 1)
            let childTodo = makeChildTodo("child task", parent: rootTodo)
    
            todoManager.createNode(rootTodo, completion: {_ in})
    
            // Act
            todoManager.createNode(childTodo) { todos in
                // Assert
                XCTAssertNotNil(todos)
                XCTAssertEqual(todos, [rootTodo])
    
                XCTAssertEqual(todos, [rootTodo])
                XCTAssertEqual(self.getToDoChild(todo: todos).titleLabel(), "Child 1.1 - child task" )
                XCTAssertEqual(self.getToDoChild(todo: todos).parentId, rootTodo.id )
                XCTAssertEqual(self.getToDoChild(todo: todos).id, childTodo.id )
                XCTAssertEqual(self.getToDoChild(todo: todos).isCompleted, childTodo.isCompleted )

                XCTAssertEqual(self.getToDoChild(todo: todos).level, 1 )

    
                XCTAssertEqual(todoManager.flattenTodos().count, 2)
            }
        }
    
    
    func test_create_SubChildTodo() throws {
            // Arrange
            let todoManager = makeSUT()
            let rootTodo = makeRootTodo("Today",taskNumber: 1)
            let childTodo = makeChildTodo("sleep", parent: rootTodo)
    
           
            todoManager.createNode(rootTodo, completion: {_ in })
            todoManager.createNode(childTodo, completion: {_ in })
    
            let subchildTodo = makeChildTodo("repeat", parent: childTodo)
    
    
    
            // Act
            todoManager.createNode(subchildTodo) { todos in
                // Assert
                XCTAssertNotNil(todos)
                XCTAssertEqual(todos, [rootTodo])
                XCTAssertEqual(todos?[0].children, [childTodo])
    
                XCTAssertEqual(self.getToDoSubChild(todo: todos).name, subchildTodo.name)
                XCTAssertEqual(self.getToDoSubChild(todo: todos).id, subchildTodo.id)
                XCTAssertEqual(self.getToDoSubChild(todo: todos).parentId, childTodo.id)
                XCTAssertEqual(self.getToDoSubChild(todo: todos).level, 2)
                XCTAssertEqual(self.getToDoSubChild(todo: todos).isCompleted,false)
                XCTAssertEqual(self.getToDoSubChild(todo: todos).titleLabel(), "Child 1.1.1 - repeat" )
    
                XCTAssertEqual(todoManager.flattenTodos().count, 3)
            }
        }
    
    func test_create_SubChildTodo_CausesAllParentsStatusToBeFalse() throws {
            // Arrange
            let todoManager = makeSUT()
        
            let rootTodo = makeRootTodo("Today",taskNumber: 1)
            rootTodo.isCompleted = true
        
            let childTodo = makeChildTodo("sleep", parent: rootTodo)
            childTodo.isCompleted = true
        
            let subchildTodo = makeChildTodo("repeat", parent: childTodo)
            childTodo.isCompleted = true

        
            todoManager.createNode(rootTodo, completion: {_ in })
            todoManager.createNode(childTodo, completion: {_ in })
    
    
            // Act
            todoManager.createNode(subchildTodo) { todos in
                // Assert
                XCTAssertEqual(self.getTodoParent(todo: todos).isCompleted,false)
                XCTAssertEqual(self.getToDoChild(todo: todos).isCompleted,false)
                XCTAssertEqual(self.getToDoSubChild(todo: todos).isCompleted,false)
               
                
            }
        }
    
    
    //MARK: HELPERS
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> TodoManager {
        let todoManager = TodoManager()
        trackMemoryLeaks(todoManager, file: file, line: line)
        return todoManager
    }
    
    private func makeRootTodo(_ name:String,taskNumber:Int = 1)->Todo{
        return Todo.createRootTodo(withName: "abdul", rootTaskNumber: taskNumber)
       }
    
    private func makeChildTodo(_ name:String,parent todo:Todo)->Todo{
            let taskCount = todo.children.count + 1
           return Todo.createChildTodo(withName: name, parent: todo, childTaskNumber: 1)
       }
    
    fileprivate func getTodoParent(todo:[Todo]?,for parent:Int = 0) -> Todo {
        return todo![parent]
    }
    fileprivate func getToDoChild(todo:[Todo]?,for parent:Int = 0,with child:Int = 0) -> Todo {
        return todo![parent].children[child] as! Todo
    }
    
    fileprivate func getToDoSubChild(todo:[Todo]?,for parent:Int = 0,with child:Int = 0,with subChild:Int = 0) -> Todo {
        let child = todo![parent].children[child] as! Todo
       return child.children[subChild] as! Todo
        
    }
    
    
    
}


public extension XCTestCase {
    
     func trackMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leaks.", file: file, line: line)
        }
    }
    
}
