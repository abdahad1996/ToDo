//
//  SceneDelegate.swift
//  RecursiveToDo
//
//  Created by macbook abdul on 14/03/2024.
//

import UIKit
import TodoShared
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var navigaitonController = UINavigationController()
    let todoManager = TodoManager()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        makeTaskListVC(windowScene)
    }

    func makeTaskListVC(_ scene:UIWindowScene){
        window = UIWindow(windowScene: scene)
        
        let mainTodoListViewController = MainTodoListViewController()
       
        let viewModel = TodoListViewModel(todoManager:todoManager)
        mainTodoListViewController.viewModel = viewModel
        
        mainTodoListViewController.addTask = { [weak self] in
            self?.makeAddTaskVC { [weak viewModel] in
                viewModel?.loadTodo()
            }
            
        }
        mainTodoListViewController.editTask = { [weak self] todo in
            self?.makeEditTaskVC(todo: todo, completion: { [weak viewModel] in
                viewModel?.onUpdateName?(todo)
            })
        }
        
        mainTodoListViewController.addSubTask = { [weak self] copiedTodo,todo in
            self?.makeSubTaskVC(todo: todo, completion: { [weak viewModel] _ in
                viewModel?.loadTodo()
                viewModel?.loadSubTodo(copy: copiedTodo)
            })
        }

        
        window?.rootViewController = navigaitonController
        window?.makeKeyAndVisible()
        
        navigaitonController.setViewControllers([mainTodoListViewController], animated: false)
      
    }

    func makeAddTaskVC(completion:@escaping () -> Void){
        let viewModel = AddTodoViewModel(todoManager: todoManager)
        
        let AddToDoView = AddTodoView(viewModel: viewModel,onCancelTapped: { [weak self] in
            self?.navigaitonController.navigationBar.isHidden = false
            self?.navigaitonController.popViewController(animated: false)
        })
        
        viewModel.onSaveTapped = {[weak self] _ in
            self?.navigaitonController.navigationBar.isHidden = false
            self?.navigaitonController.popViewController(animated: true)
            completion()
        }
        
        
        
        let AddToDoViewController = UIHostingController(rootView: AddToDoView)
        self.navigaitonController.pushViewController(AddToDoViewController, animated: true)
        self.navigaitonController.navigationBar.isHidden = true
    }
    
    func makeEditTaskVC(todo:Todo,completion:@escaping () -> Void){
        let viewModel = EditTodoViewModel(todoUpdater: todoManager, todo: todo)
        let EditTodoView = EditTodoView(viewModel: viewModel,onCancelTapped: { [weak self] in
            self?.navigaitonController.navigationBar.isHidden = false
            self?.navigaitonController.popViewController(animated: true)
        })
        
        viewModel.onSaveTapped = {[weak self] _ in
            self?.navigaitonController.navigationBar.isHidden = false
            self?.navigaitonController.popViewController(animated: false)
            completion()
        }
        
        
        
        let AddToDoViewController = UIHostingController(rootView: EditTodoView)
        self.navigaitonController.pushViewController(AddToDoViewController, animated: true)
        self.navigaitonController.navigationBar.isHidden = true
    }
    
    //create subtask
    func makeSubTaskVC(todo:Todo,completion:@escaping ([Todo]) -> Void){
        let viewModel = AddSubTodoViewModel(todoManager: todoManager, todo: todo)
        
        let AddToDoView = AddSubTodoView(viewModel: viewModel,onCancelTapped: { [weak self] in
            self?.navigaitonController.navigationBar.isHidden = false
            self?.navigaitonController.popViewController(animated: false)
        })
        
        viewModel.onSaveTapped = {[weak self] todos in
            self?.navigaitonController.navigationBar.isHidden = false
            self?.navigaitonController.popViewController(animated: true)
            completion(todos)
        }
        
        
        
        let AddToDoViewController = UIHostingController(rootView: AddToDoView)
        self.navigaitonController.pushViewController(AddToDoViewController, animated: true)
        self.navigaitonController.navigationBar.isHidden = true
    }


}

