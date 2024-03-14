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
    
    func test_loads_loadsEmptyTodo(){
           // Arrange
           let todoManager = makeSUT()
   
           // Act
           todoManager.load { todos in
               // Assert
               XCTAssertEqual(todos,[])
               XCTAssertEqual(todoManager.flattenTodos().count,0)
   
           }
       }
 
       func test_loads_SuccessfullyloadsTodo(){
           // Arrange
           let todoManager = makeSUT()
   
           let task1 = makeRootTodo("Task 1")
           let task2 = makeRootTodo("Task 2")
           let task3 = makeRootTodo("Task 3")
   
           todoManager.createNode(task1, completion: {_ in })
           todoManager.createNode(task2, completion: {_ in })
           todoManager.createNode(task3, completion: {_ in })

           // Act
           todoManager.load { todos in
               // Assert
               XCTAssertEqual(todos,[task1,task2,task3])
               XCTAssertEqual(todoManager.flattenTodos().count,3)
   
           }
       }
    
}
