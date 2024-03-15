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
    
    func test_updates_TogglesChangesFromParentToAllChildren() throws{
        let todoManager = makeSUT()
        let (todo1, childTodo1, subChildTodo1, subSubChildTodo1) = createHeirchialTodos()

        [todo1,childTodo1,subChildTodo1,subSubChildTodo1].forEach { todo in
            todoManager.createNode(todo, completion: {_ in })
        }
        

        // Act
        todoManager.updateStatus(todo1) { todos in
            XCTAssertEqual(getTodoParent(todo: todos).isCompleted,true)
            XCTAssertEqual(getToDoChild(todo: todos).isCompleted,true)
            XCTAssertEqual(getToDoSubChild(todo: todos).isCompleted,true)
            XCTAssertEqual(getToDoSubSubChild(todo: todos).isCompleted,true)

            

        }
    }
    
    func test_updates_TogglesCompleteStatusFromChildTodo_CausesUpdateToAllChildrenAndParents() throws{
        let todoManager = makeSUT()
        let (todo1, childTodo1, subChildTodo1, subSubChildTodo1) = createHeirchialTodos()

        [todo1,childTodo1,subChildTodo1,subSubChildTodo1].forEach { todo in
            todoManager.createNode(todo, completion: {_ in })
        }
        

        // Act
        todoManager.updateStatus(childTodo1) { todos in
            XCTAssertEqual(getTodoParent(todo: todos).isCompleted,true)
            XCTAssertEqual(getToDoChild(todo: todos).isCompleted,true)
            XCTAssertEqual(getToDoSubChild(todo: todos).isCompleted,true)
            XCTAssertEqual(getToDoSubSubChild(todo: todos).isCompleted,true)

        }
    }
    
    
    func test_updates_TogglesCompleteStatusForSubChildTodoCausesUpdatesToOnlyImmediateParent(){
        
        let todoManager = makeSUT()
        let todo1 = makeRootTodo("Task 1")
       
        let childTodo1 = makeChildTodo("Task 1.1", parent: todo1)
        let subChildTodo1 = makeChildTodo("Task 1.1.1", parent: childTodo1)
        let subSubChildTodo1 = makeChildTodo("Task 1.1.1.1", parent: subChildTodo1)
        
        let childTodo2 = makeChildTodo("abdul", parent: todo1)
        let subChildTodo2 = makeChildTodo("abdul", parent: childTodo2)
        let subSubChildTodo2 = makeChildTodo("abdul", parent: subChildTodo2)



        [todo1,childTodo1,childTodo2,subChildTodo1,subChildTodo2,subSubChildTodo1,subSubChildTodo2].forEach { todo in
            
            todoManager.createNode(todo, completion: {_ in })
        }
        

        // Act
        todoManager.updateStatus(subSubChildTodo1) { todos in
            XCTAssertEqual(getTodoParent(todo: todos).isCompleted,false)
            
            XCTAssertEqual(getToDoChild(todo: todos,with:0).isCompleted,true)
            XCTAssertEqual(getToDoChild(todo: todos,with:1).isCompleted,false)

            XCTAssertEqual(getToDoSubChild(todo: todos,with:0).isCompleted,true)
            XCTAssertEqual(getToDoSubChild(todo: todos,with: 1).isCompleted,false)

            XCTAssertEqual(getToDoSubSubChild(todo: todos,with:0).isCompleted,true)
            XCTAssertEqual(getToDoSubSubChild(todo: todos,with:1).isCompleted,false)

            

        }
    }

    
}


