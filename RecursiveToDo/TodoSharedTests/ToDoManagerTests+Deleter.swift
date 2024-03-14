//
//  ToDoManagerTests.swift
//  TodoSharedTests
//
//  Created by macbook abdul on 14/03/2024.
//

import Foundation
import XCTest
import TodoShared

extension ToDoManager {
    
        func test_deleteNode_RemovesSingleParentFromTodoArray(){
            // Arrange
            let todoManager = makeSUT()
    
            let task1 = makeRootTodo("Task 1")
            let task2 = makeRootTodo("Task 2")
            let task3 = makeRootTodo("Task 3")
    
            
            [task1,task2,task3].forEach { todo in
                todoManager.createNode(todo, completion: {_ in })
            }
    
            // Act
            
            todoManager.deleteNode(task1) { todos in
                //Assert
                XCTAssertEqual(todos, [task2,task3])
                XCTAssertEqual(todoManager.flattenTodos().count, 2)
    
            }
        
        }
    
        func test_deleteNode_RemovesParentAndAllRecursiveChildrenFromTodoArray(){
            let todoManager = makeSUT()
            let (todo1, childTodo1, subChildTodo1, subSubChildTodo1) = createHeirchialTodos()


            
            [todo1,childTodo1,subChildTodo1,subSubChildTodo1].forEach { todo in
                todoManager.createNode(todo, completion: {_ in })
            }

            
            todoManager.deleteNode(todo1) { todos in
                XCTAssertEqual(todos, [])
                XCTAssertEqual(todoManager.flattenTodos().count, 0)

    
            }
        }
    
        func test_deleteNode_RemovesSingleLeafChildFromTodoArray(){
            let todoManager = makeSUT()
            let (todo1, childTodo1, subChildTodo1, subSubChildTodo1) = createHeirchialTodos()


            
            [todo1,childTodo1,subChildTodo1,subSubChildTodo1].forEach { todo in
                todoManager.createNode(todo, completion: {_ in })
            }
    
            // Act
            todoManager.deleteNode(subSubChildTodo1) { todos in
                XCTAssertEqual(todoManager.flattenTodos().count, 3)
    
            }
        }
    
        func test_deletes_RemovesChildAndAllChildrenFromTodoArray(){
            let todoManager = makeSUT()
            let (todo1, childTodo1, subChildTodo1, subSubChildTodo1) = createHeirchialTodos()


            
            [todo1,childTodo1,subChildTodo1,subSubChildTodo1].forEach { todo in
                todoManager.createNode(todo, completion: {_ in })
            }
            
    
            // Act
            todoManager.deleteNode(subChildTodo1) { todos in
                XCTAssertEqual(todoManager.flattenTodos().count, 2)
    
            }
        }
    //
    
    //MARK: Helpers
    
    func createHeirchialTodos() -> (Todo, Todo, Todo, Todo) {
        let todo1 = makeRootTodo("Task 1")
        let childTodo1 = makeChildTodo("Task 1.1", parent: todo1)
        let subChildTodo1 = makeChildTodo("Task 1.1.1", parent: childTodo1)
        let subSubChildTodo1 = makeChildTodo("Task 1.1.1.1", parent: subChildTodo1)
        return (todo1, childTodo1, subChildTodo1, subSubChildTodo1)
    }
   

}
