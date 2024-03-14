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
@protocol TodoDeleter <NSObject>

// Declare a method to delete a todo node
- (void)deleteNode:(Todo *)node completion:(void (^)(NSArray<Todo *> *))completion;

@end
