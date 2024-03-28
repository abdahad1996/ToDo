//
//  MainTodoListViewController.swift
//  Todo
//
//  Created by macbook abdul on 12/03/2024.
//

import Foundation
import UIKit
import TodoShared

extension Todo: NSItemProviderWriting {
    
    public static var writableTypeIdentifiersForItemProvider: [String] {
        return ["Todo"]
    }
    
    public func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        return nil
    }
    
}
// MARK:- UITableView UITableViewDragDelegate
extension MainTodoListViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        // Set the local context to include the source index path
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        
        let localContext = ["sourceIndexPath": indexPath]
        dragItem.localObject = localContext
        return [dragItem]
    }
}
 



//MARK: Helper Functions
extension MainTodoListViewController {
     func updateNameRow(with updatedTodo: Todo) {
        // Reload or insert rows based on changeset
        tableView.beginUpdates()
        guard let index = self.todos.firstIndex(of: updatedTodo) else{return}
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
    }
    
     func updateIsCompletedRows(copy: [Todo], updated: [Todo]) {
        todos = updated
        let changeset = Todo.indexesOfChangedIsCompleted(original: copy, updated: updated)
        // Reload or insert rows based on changeset
        tableView.beginUpdates()
        
        var indexPath = [IndexPath]()
        changeset.forEach { index in
            indexPath.append(IndexPath(row: index, section: 0))
        }
        tableView.reloadRows(at:indexPath, with: .automatic)
        
        tableView.endUpdates()
    }
    
     func deleteTableRows(with newTodos: [Todo]) {
        
        let oldTodos = todos
        todos = newTodos
        let changeset = Todo.indexesOfDeletedTodos(original: oldTodos, updated: todos)
        
        // Reload or insert rows based on changeset
        tableView.beginUpdates()
        
        var indexPath = [IndexPath]()
        changeset.forEach { index in
            indexPath.append(IndexPath(row: index, section: 0))
        }
        
        tableView.deleteRows(at:indexPath, with: .automatic)
        
        if todos.isEmpty{
            self.showEmptyView()
        }
        tableView.endUpdates()
    }
    
    
    
    
    func InsertTableRow(with newTodos: [Todo]) {
        let oldTodos = todos
        todos = newTodos
        
        tableView.beginUpdates()
        
        let changeset = Todo.indexesOfAddedTodos(original: oldTodos,updated: newTodos)
        var indexPath = [IndexPath]()
        changeset.forEach { index in
            indexPath.append(IndexPath(row: index, section: 0))
        }
        tableView.insertRows(at: indexPath, with: .automatic)
        
        
        tableView.endUpdates()
    }
    
}

