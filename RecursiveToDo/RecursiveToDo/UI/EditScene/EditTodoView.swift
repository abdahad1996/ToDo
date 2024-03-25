//
//  EditTodoView.swift
//  Todo
//
//  Created by macbook abdul on 12/03/2024.
//

import SwiftUI
import TodoShared

struct EditTodoView: View {
    @ObservedObject var viewModel: EditTodoViewModel
    var onCancelTapped: (() -> Void)?
    var onSaveTapped: (() -> Void)?

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
            
    }
}



#Preview {
    EditTodoView(viewModel: EditTodoViewModel(todoUpdater: TodoUpdaterPreviewStub(),todo: Todo.createRootTodo(withName: "test", rootTaskNumber: 1)))
}

fileprivate final class TodoUpdaterPreviewStub:NSObject, TodoNameUpdater {
    func updateName(_ name: String!, id: String!, completion: (([Todo]?) -> Void)!) {
         
    }
    
    
}
