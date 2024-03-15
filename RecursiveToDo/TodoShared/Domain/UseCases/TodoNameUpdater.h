//
//  TodoAdder.h
//  Todo
//
//  Created by macbook abdul on 14/03/2024.
//

#import <Foundation/Foundation.h>

// Forward declaration of the Todo class
@class Todo;

// Declare the protocol for updating todo name
@protocol TodoNameUpdater <NSObject>

// Declare a method to update todo name
- (void)updateName:(NSString *)name id:(NSString *)id completion:(void (^)(NSArray<Todo *> *))completion;

@end
