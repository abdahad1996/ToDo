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
    for (int i=0; i < tree.count; i++) {
        tree[i].taskNumber = [NSString stringWithFormat:@"%d", i+1];
        [self assignTaskNumberToChildren:tree[i]];
    }
    
    self.todos = [tree mutableCopy];
    
    //call completion
    completion(tree);
}

- (void)assignTaskNumberToChildren:(Todo *)todo {
    if (todo.children.count > 0) {
        for (int i=0; i < todo.children.count; i++) {
            Todo *item = todo.children[i];
            item.taskNumber = [NSString stringWithFormat:@"%@.%d", todo.taskNumber, i+1];
            [self assignTaskNumberToChildren:item];
        }
    }
}

+ (NSArray<Todo *> *)makeTreeFromFlattenedTodos:(NSArray<Todo *> *)flattenedTodos {
    NSMutableDictionary<NSString *, Todo *> *todoMap = [NSMutableDictionary dictionary]; // Map to store todos by their IDs
    NSMutableArray<Todo *> *rootTodos = [NSMutableArray array];

    // Create a map of todos by their IDs
    for (Todo *todo in flattenedTodos) {
        [todo.children removeAllObjects];
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
