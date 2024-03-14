//
//  TodoManager+TodoCreator.m
//  TodoShared
//
//  Created by macbook abdul on 14/03/2024.
//

#import <TodoShared/TodoManager.h>
#import <TodoShared/TodoAdder.h>
#import <TodoShared/Todo.h>

@implementation TodoManager (TodoAdder)

- (void)createNode:(Todo *)node completion:(void (^)(NSArray<Todo *> *))completion {
    NSString *parentId = node.parentId ?: @"";

    Todo *parent = [self findNearestParentForId:parentId];
    if (parent) {
        // Find parent and append child
        [parent.children addObject:node];
        
        // Check if it is a child and all other children and parents are completed then mark subroot and root task as incompleted
        [self markAllCompletedParentsStatusToIncompleteOnAdditionOfNewSubtaskForId:parentId];
        
        completion([self todos]);
    } else {
        [[self todos] addObject:node];
        completion([self todos]);
    }
}
    

@end
