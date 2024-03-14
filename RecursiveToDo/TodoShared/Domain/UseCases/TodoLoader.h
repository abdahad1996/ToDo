//
//  TodoAdder.h
//  Todo
//
//  Created by macbook abdul on 14/03/2024.
//

#import <Foundation/Foundation.h>

// Forward declaration of the Todo class
@class Todo;

// Declare the protocol
@protocol TodoLoader <NSObject>

// Declare a method to load a todo node
- (void)loadWithCompletion:(void (^)(NSArray<Todo *> *todos))completion;
@end
