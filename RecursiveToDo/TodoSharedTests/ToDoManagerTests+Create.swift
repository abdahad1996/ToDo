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
                XCTAssertEqual(getToDoChild(todo: todos).titleLabel(), "Child 1.1 - child task" )
                XCTAssertEqual(getToDoChild(todo: todos).parentId, rootTodo.id )
                XCTAssertEqual(getToDoChild(todo: todos).id, childTodo.id )
                XCTAssertEqual(getToDoChild(todo: todos).isCompleted, childTodo.isCompleted )

                XCTAssertEqual(getToDoChild(todo: todos).level, 1 )

    
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
    
                XCTAssertEqual(getToDoSubChild(todo: todos).name, subchildTodo.name)
                XCTAssertEqual(getToDoSubChild(todo: todos).id, subchildTodo.id)
                XCTAssertEqual(getToDoSubChild(todo: todos).parentId, childTodo.id)
                XCTAssertEqual(getToDoSubChild(todo: todos).level, 2)
                XCTAssertEqual(getToDoSubChild(todo: todos).isCompleted,false)
                XCTAssertEqual(getToDoSubChild(todo: todos).titleLabel(), "Child 1.1.1 - repeat" )
    
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
                XCTAssertEqual(getTodoParent(todo: todos).isCompleted,false)
                XCTAssertEqual(getToDoChild(todo: todos).isCompleted,false)
                XCTAssertEqual(getToDoSubChild(todo: todos).isCompleted,false)
               
                
            }
        }
    
    
    //MARK: HELPERS
     func makeSUT(file: StaticString = #file, line: UInt = #line) -> TodoManager {
        let todoManager = TodoManager()
        trackMemoryLeaks(todoManager, file: file, line: line)
        return todoManager
    }
    
   
    
    
}


public extension XCTestCase {
    
     func trackMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leaks.", file: file, line: line)
        }
    }
    
}
