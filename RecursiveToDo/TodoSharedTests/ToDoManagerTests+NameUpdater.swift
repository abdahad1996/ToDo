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
    
    func test_update_updatesNameForGivenNode()
   
    {
            // Arrange
    
        let todoManager = makeSUT()
        let (todo1, childTodo1, subChildTodo1, subSubChildTodo1) = createHeirchialTodos()


        
        [todo1,childTodo1,subChildTodo1,subSubChildTodo1].forEach { todo in
            todoManager.createNode(todo, completion: {_ in })
        }
    
            // Act
            todoManager.updateName("Updated task 1", id: todo1.id) { todos in
                XCTAssertEqual(getTodoParent(todo: todos).name,"Updated task 1")
            }
    
            todoManager.updateName( "Updated task 1.1", id: childTodo1.id) { todos in
                XCTAssertEqual(getToDoChild(todo: todos).name,"Updated task 1.1")
            }
    
            todoManager.updateName( "Updated task 1.1.1", id: subChildTodo1.id) { todos in
                XCTAssertEqual(getToDoSubChild(todo: todos).name,"Updated task 1.1.1")
            }
        
        }
    
}


