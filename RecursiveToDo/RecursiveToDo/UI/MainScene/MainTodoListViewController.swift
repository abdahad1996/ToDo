//
//  MainTodoListViewController.swift
//  Todo
//
//  Created by macbook abdul on 12/03/2024.
//

import Foundation
import UIKit
import TodoShared

class MainTodoListViewController: UITableViewController {
    
    var addSubTask: (([Todo],Todo) -> Void)?
    var addTask: (() -> Void)?
    var editTask: ((Todo) -> Void)?
    var moveAfterDeletion:(([Todo]) -> Void)?

    var viewModel: TodoListViewModel? {
        didSet { bind() }
    }
    
     var todos = [Todo]()
    
   
    
    func bind() {
        
        viewModel?.onLoad = { [weak self] todos in
            if todos.isEmpty {
                self?.showEmptyView()
            }else{
                self?.hideEmptyView()
                self?.InsertTableRow(with: todos)
            }
            
        }
        viewModel?.onMove = { [weak self] todos in
            self?.todos = todos
            self?.tableView.reloadData()
//            self?.InsertTableRow(with: todos)
           
        }
        
        viewModel?.onUpdateName = { [weak self] updatedTodo in
            self?.updateNameRow(with: updatedTodo)
        }
        
        viewModel?.onDeleteNode = { [weak self] todos in
            self?.deleteTableRows(with: todos)
            self?.moveAfterDeletion?(todos)
            
        }
        //
        viewModel?.onUpdateIsCompletedStatus = { [weak self] todos in
            self?.updateIsCompletedRows(copy: todos.copyTodos,updated: todos.updatedTodos)
            
        }
        
        viewModel?.onReloadingCompleteStatusWhenSubTaskAdded = { [weak self] copyTodos in
            self?.updateIsCompletedRows(copy:copyTodos,updated: self?.todos ?? [])

        }
        
        viewModel?.loadTodo()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView() // To hide empty rows
        tableView.register(TodoViewCell.self, forCellReuseIdentifier: "TodoViewCell")
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true

        
        self.title = "My tasks"
        
        let addButton = UIBarButtonItem(title: "Add Tasks", style: .plain, target: self, action: #selector(addButtonTapped))
        self.navigationItem.rightBarButtonItem = addButton
        
        
    }
    
   
    
     func showEmptyView() {
        let emptyLabel = UILabel()
        emptyLabel.text = "No data available please add a task"
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .gray
        tableView.backgroundView = emptyLabel
    }
    
    private func hideEmptyView() {
        tableView.backgroundView = nil
    }
    
    @objc func addButtonTapped() {
        // Implement the action here
        self.addTask?()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoViewCell", for: indexPath) as! TodoViewCell
        
        let todoModel = todos[indexPath.row]
        cell.model = todoModel
        
        cell.onCheckboxStateChanged = { [weak self] node in
            guard let self = self else{return}
            self.viewModel?.update(copy: self.todos.map{$0.copy() as! Todo}, node: node)
        }
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        editTask?(todos[indexPath.row])
    }
    
    // MARK: - Swipe Actions
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action1 = UIContextualAction(style: .normal, title: "Add Subtask") { (action, view, completionHandler) in
            let copyTodo =  self.todos.map{$0.copy() as! Todo}
            self.addSubTask?(copyTodo,self.todos[indexPath.row])
            completionHandler(true)
        }
        action1.backgroundColor = .green
        
        
        let action2 = UIContextualAction(style: .normal, title: "Delete") {  (action, view, completionHandler) in
            
            let todoModel = self.todos[indexPath.row]
            print(todoModel)
            self.viewModel?.deleteTodo(node: todoModel)
            
            completionHandler(true)
        }
        action2.backgroundColor = .red
        
        
        let configuration = UISwipeActionsConfiguration(actions: [action1, action2])
        return configuration
    }
    
    
    // Row Editable true
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
           return true
   }
      
       // Move Row Instance Method
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
           print("\(sourceIndexPath.row) -> \(destinationIndexPath.row)")
        
        if sourceIndexPath.row == destinationIndexPath.row {
            return
        }
        
        let moveCell = self.todos[sourceIndexPath.row]
       
        self.todos.remove(at: sourceIndexPath.row)
        self.todos.insert(moveCell, at: destinationIndexPath.row)
        self.viewModel?.move(flatArr:  self.todos)
   }
    
}

// MARK:- UITableView UITableViewDropDelegate
extension MainTodoListViewController: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        
        // Get the drag item
            let dragItem = session.items.first!

            // Retrieve the source index path from the local context
            guard let localContext = dragItem.localObject as? [String: Any],
                  let sourceIndexPath = localContext["sourceIndexPath"] as? IndexPath else {
                return UITableViewDropProposal(operation: .cancel)
            }

        guard let destinationIndexPath = destinationIndexPath, destinationIndexPath.row <= todos.count-1 else{ return UITableViewDropProposal(operation: .cancel)
        }
   
            //same level
        if (todos[destinationIndexPath.row].parentId != todos[sourceIndexPath.row].parentId) {
                    return UITableViewDropProposal(operation: .cancel)
        }

        
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
}
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) { }
}
