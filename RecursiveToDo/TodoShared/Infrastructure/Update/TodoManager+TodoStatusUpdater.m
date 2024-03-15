//
//  TodoManager+TodoLoader.m
//  TodoShared
//
//  Created by macbook abdul on 14/03/2024.
//

#import <TodoShared/TodoManager.h>
#import <TodoShared/TodoManager+TodoStatusUpdater.h>
#import <TodoShared/Todo.h>

@implementation TodoManager (TodoStatusUpdater)

- (void)updateStatus:(Todo *)node completion:(void (^)(NSArray<Todo *> *))completion { 
    //update node
    node.isCompleted = !node.isCompleted;
    NSString *parentId = node.parentId ?: @"";

    Todo *parent = [self findNearestParentForId:parentId];
    if (parent) {
        
       //check if the node has children that means it is a subroot task hence toggle all it's children
        if (node.children.count > 0) {
            for (Todo *child in  [self flattenChildren:node.children]) {
                child.isCompleted = node.isCompleted;
            }
        }
        
        //move up and check for status of each parent
        [self iterateOverEachParentAndCheckStatusUntilRootForId:node.parentId];
    }
    else{
        //root todo so toggle all children status
//        [self toggleStatusOfAnyParentAndAllChildren:node];
        for (Todo *child in  [self flattenChildren:node.children]) {
            child.isCompleted = node.isCompleted;
        }
        
    }
    completion([self todos]);
}

@end
