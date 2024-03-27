//
//  TodoManager+TodoLoader.m
//  TodoShared
//
//  Created by macbook abdul on 14/03/2024.
//

#import <TodoShared/TodoManager.h>
#import <TodoShared/TodoManager+TodoLoader.h>
#import <TodoShared/Todo.h>

@implementation TodoManager (TodoLoader)


- (void)loadWithCompletion:(void (^)(NSArray<Todo *> *todos))completion{
    completion([self todos]);
}

@end
