//
//  TodoManager+TodoLoader.m
//  TodoShared
//
//  Created by macbook abdul on 14/03/2024.
//

#import <TodoShared/TodoManager.h>
#import <TodoShared/TodoManager+TodoDeleter.h>
#import <TodoShared/Todo.h>

@implementation TodoManager (TodoDeleter)

- (void)removeTodoWithId:(NSString *)todoId fromArray:(NSMutableArray<Todo *> *)todosArray {
    NSInteger indexOfMatchedTodo = -1;
    
    for (NSInteger i = 0; i < todosArray.count; i++) {
        Todo *todo = todosArray[i];
        // Check the condition for each todo
        if ([todo.id isEqualToString:todoId]) {
            // Condition is true for this todo
            NSLog(@"Found todo: %@", todo);
            indexOfMatchedTodo = i; // Store the index of the matched todo
            break; // Exit the loop since we found the first match
        }
    }
    
    if (indexOfMatchedTodo != -1) {
        // Remove the item at the specified index
        [todosArray removeObjectAtIndex:indexOfMatchedTodo];
    }
}

- (void)deleteNode:(Todo *)node completion:(void (^)(NSArray<Todo *> *))completion {
    NSString *parentId = node.parentId ?: @"";
    Todo *parent = [self findNearestParentForId:parentId];
        if (parent) {
//            if ([node children].count > 0) {
            
//                [node.children removeAllObjects];
                [self removeTodoWithId:node.id fromArray:parent.children];

//            }else{
//                //leaf node
////                parent.children.
//            }
//            // Find parent and delete child
//            NSMutableArray<Todo *> *children = node.children;
//            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Todo *todo, NSDictionary *bindings) {
//                return [todo.id isEqualToString:node.id];
//            }];
//            [children filterUsingPredicate:predicate];
//            parent.children
//            [self deleteNodeAndChildren:node fromArray:node.children];
            
            completion([self todos]);
        } else {
            
            // Iterate through the array
//            NSInteger indexOfMatchedTodo = -1;
//            for (NSInteger i = 0; i < [self todos].count; i++) {
//                Todo *todo = [self todos][i];
//                // Check the condition for each todo
//                if (node.id == todo.id) {
//                    // Condition is true for this todo
//                    NSLog(@"Found todo: %@", todo);
//                    indexOfMatchedTodo = i; // Store the index of the matched todo
//                    break; // Exit the loop since we found the first match
//                }
//            }
//            
//            if (indexOfMatchedTodo >= 0 && indexOfMatchedTodo < [self todos].count) {
//                // Remove the item at the specified index
//                [[self todos] removeObjectAtIndex:indexOfMatchedTodo];
//            }
            
            [self removeTodoWithId:node.id fromArray:[self todos]];

            
            completion([self todos]);
        }
    }


@end
