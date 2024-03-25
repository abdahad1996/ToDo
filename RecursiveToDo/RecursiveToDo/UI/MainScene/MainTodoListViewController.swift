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
    
    var viewModel: TodoListViewModel? {
        didSet { bind() }
    }
    
    private var todos = [Todo]()
    
   
    
    func bind() {
        
        viewModel?.onLoad = { [weak self] todos in
            if todos.isEmpty {
                self?.showEmptyView()
            }else{
                self?.hideEmptyView()
                self?.InsertTableRow(with: todos)
            }
            
        }
        
        viewModel?.onUpdateName = { [weak self] updatedTodo in
            self?.updateNameRow(with: updatedTodo)
        }
        
        viewModel?.onDeleteNode = { [weak self] todos in
            self?.deleteTableRows(with: todos)
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
    
   
    
    private func showEmptyView() {
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
//            let copyTodo =  self.todos.map{$0.copy() as! Todo}
            self.addSubTask?([],self.todos[indexPath.row])
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
           let moveCell = self.todos[sourceIndexPath.row]
           self.todos.remove(at: sourceIndexPath.row)
           self.todos.insert(moveCell, at: destinationIndexPath.row)
   }
    
}


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
        // If needed, you can get a reference to the cell being dragged using the index path

        print("\(todos[destinationIndexPath.row].level) == \(todos[sourceIndexPath.row].level)")

        if todos[destinationIndexPath.row].level == todos[sourceIndexPath.row].level{
            if session.localDragSession != nil {
                return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
        }


           // If needed, you can get a reference to the cell being dragged using the index path

        
       
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
}
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) { }
}



//MARK: Helper Functions
extension MainTodoListViewController {
    fileprivate func updateNameRow(with updatedTodo: Todo) {
        guard let index = self.todos.firstIndex(of: updatedTodo) else{return}
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    fileprivate func updateIsCompletedRows(copy: [Todo], updated: [Todo]) {
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
    
    fileprivate func deleteTableRows(with newTodos: [Todo]) {
        
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

