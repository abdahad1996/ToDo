//
//  AddTodoView.swift
//  Todo
//
//  Created by macbook abdul on 13/03/2024.
//

import SwiftUI
import TodoShared

struct AddSubTodoView: View {
    @ObservedObject var viewModel: AddSubTodoViewModel
    var onCancelTapped: (() -> Void)?

    var body: some View {
        NavigationView{
            VStack {
                // Your main content goes here
                HStack {
                    Text(viewModel.title)
                        .font(.system(size: 25))
                    Spacer()
                }.padding()
                TextField(viewModel.placeholder, text: $viewModel.text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .border(Color.black)
                    .padding()
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(viewModel.cancel) {
                        onCancelTapped?()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(viewModel.saveTitle) {
                        viewModel.save()
                    }.disabled(viewModel.text.isEmpty)
                }
                
            }
        }
//        .navigationBarTitle("")
//            .navigationBarHidden(true)
            
    }
}


#Preview {
    AddSubTodoView(viewModel: AddSubTodoViewModel(todoManager: TodoAdderPreviewStub(), todo: Todo.createRootTodo(withName: "test", rootTaskNumber: 1)))
}
fileprivate final class TodoAdderPreviewStub:NSObject, TodoAdder,TodoLoader {
    func createNode(_ node: Todo!, completion: (([Todo]?) -> Void)!) {
        
    }
    
    
    func load(completion: (([Todo]?) -> Void)!) {
        
    }
    

    
}
