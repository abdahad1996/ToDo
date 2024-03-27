//
//  TodoLocal.swift
//  TodoShared
//
//  Created by macbook abdul on 26/03/2024.
//

import Foundation

public struct LocalTodo {
    var name: String
    var children: [LocalTodo]
    var level: Int
    var id: String
    var parentId: String?
    var isCompleted: Bool
    var taskNumber: String

    public init(name: String,
         children: [LocalTodo],
         level: Int,
         id: String,
         parentId: String?,
         isCompleted: Bool,
         taskNumber: String) {
        self.name = name
        self.children = children
        self.level = level
        self.id = id
        self.parentId = parentId
        self.isCompleted = isCompleted
        self.taskNumber = taskNumber
    }
}
