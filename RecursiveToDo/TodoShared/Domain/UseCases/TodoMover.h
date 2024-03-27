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
@protocol TodoMover <NSObject>

// Declare a method to create a todo node
-(void)move:(NSArray<Todo *> *)flattenArr completion:(void (^)(NSArray<Todo *> *))completion;
@end
