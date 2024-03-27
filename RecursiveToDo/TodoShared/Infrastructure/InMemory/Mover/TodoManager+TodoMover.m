//
//  TodoManager+TodoLoader.m
//  TodoShared
//
//  Created by macbook abdul on 14/03/2024.
//

#import <TodoShared/TodoManager.h>
#import <TodoShared/TodoManager+TodoMover.h>
#import <TodoShared/Todo.h>

@implementation TodoManager (TodoMover)



- (void)move:(NSArray<Todo *> *)flattenArr completion:(void (^)(NSArray<Todo *> *))completion { 
    NSArray<Todo *> *tree = [TodoManager makeTreeFromFlattenedTodos:flattenArr];
    //
    // update according to index
    
//    self.todos = todo
    
    //call completion
}


+ (NSArray<Todo *> *)makeTreeFromFlattenedTodos:(NSArray<Todo *> *)flattenedTodos {
    NSMutableDictionary<NSString *, Todo *> *todoMap = [NSMutableDictionary dictionary]; // Map to store todos by their IDs
    NSMutableArray<Todo *> *rootTodos = [NSMutableArray array];

    // Create a map of todos by their IDs
    for (Todo *todo in flattenedTodos) {
        todoMap[todo.id] = todo;
    }

    // Traverse the flattened list to build the tree
    for (Todo *todo in flattenedTodos) {
        NSString *parentId = todo.parentId;
        Todo *parent = todoMap[parentId];
        
        if (parent) {
            // If todo has a parent, add it to its parent's children array
            [parent.children addObject:todo];
        } else {
            // If todo doesn't have a parent, it's a root todo
            [rootTodos addObject:todo];
        }
    }

    return rootTodos;
}


@end
