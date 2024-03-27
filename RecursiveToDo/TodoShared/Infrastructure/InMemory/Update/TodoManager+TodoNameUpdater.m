//
//  TodoManager+TodoLoader.m
//  TodoShared
//
//  Created by macbook abdul on 14/03/2024.
//

#import <TodoShared/TodoManager.h>
#import <TodoShared/TodoManager+TodoNameUpdater.h>
#import <TodoShared/Todo.h>

@implementation TodoManager (TodoNameUpdater)

- (void)updateName:(NSString *)name id:(NSString *)id completion:(void (^)(NSArray<Todo *> *))completion {
    
    for (NSInteger i = 0; i < [self flattenTodos].count; i++) {
        Todo *todo = [self flattenTodos][i];
        
        if ([id isEqualToString:todo.id]) {
            // Condition is true for this todo
            NSLog(@"Found todo: %@", todo);
            todo.name = name; // Store the index of the matched todo
            break; // Exit the loop since we found the first match
        }
    }
    completion([self todos]);
}



@end
