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
   
           let (task1, task2, task3) = createRootTodos()

           
           [task1,task2,task3].forEach { todo in
               todoManager.createNode(todo, completion: {_ in })
           }

           // Act
           todoManager.load { todos in
               // Assert
               XCTAssertEqual(todos,[task1,task2,task3])
               XCTAssertEqual(todoManager.flattenTodos().count,3)
   
           }
       }
    
}
