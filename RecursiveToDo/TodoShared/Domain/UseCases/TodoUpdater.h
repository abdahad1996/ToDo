//
//  TodoAdder.h
//  Todo
//
//  Created by macbook abdul on 14/03/2024.
//

#import <Foundation/Foundation.h>

// Forward declaration of the Todo class
@class Todo;

// Declare the protocol for updating todo status
@protocol TodoStatusUpdater <NSObject>

// Declare a method to update todo status
- (void)updateNode:(Todo *)node completion:(void (^)(NSArray<Todo *> *))completion;

@end

// Declare the protocol for updating todo name
@protocol TodoNameUpdater <NSObject>

// Declare a method to update todo name
- (void)updateName:(NSString *)name id:(NSString *)id completion:(void (^)(NSArray<Todo *> *))completion;

@end
