//
//  TodoManager.m
//  TodoShared
//
//  Created by macbook abdul on 14/03/2024.
//

#import <TodoShared/TodoManager.h>
#import <TodoShared/Todo.h>

@implementation TodoManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _todos = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray<Todo *> *)flattenTodos {
    NSMutableArray<Todo *> *flattenedTodos = [[NSMutableArray alloc] init];
    for (Todo *todo in self.todos) {
        [flattenedTodos addObject:todo];
        [flattenedTodos addObjectsFromArray:[self flattenChildren:todo.children]];
    }
    return [flattenedTodos copy];
}

- (Todo *)findNearestParentForId:(NSString *)parentId {
    return [[self flattenTodos] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id == %@", parentId]].firstObject;
}

- (void)markAllCompletedParentsStatusToIncompleteOnAdditionOfNewSubtaskForId:(NSString *)parentId {
    Todo *currentParent = [self findNearestParentForId:parentId];
    if (currentParent.isCompleted) {
        currentParent.isCompleted = NO;
    }
    while (currentParent.parentId) {
        currentParent = [self findNearestParentForId:currentParent.parentId];
        if (currentParent.isCompleted) {
            currentParent.isCompleted = NO;
        }
    }
}

- (void)iterateOverEachParentAndCheckStatusUntilRootForId:(NSString *)parentId {
    Todo *currentParent = [self findNearestParentForId:parentId];
    if (!currentParent) {
        return;
    }
    [self toggleStatusOfParent:currentParent];
    while (currentParent.parentId) {
        currentParent = [self findNearestParentForId:currentParent.parentId];
        [self toggleStatusOfParent:currentParent];
    }
}

- (void)toggleStatusOfParent:(Todo *)parent {
    NSMutableArray<Todo *> *flattenedTodos = [[NSMutableArray alloc] init];
    [flattenedTodos addObjectsFromArray:[self flattenChildren:parent.children]];
    
    BOOL allSubtasksCompleted = YES;
       
       // Check if all subtasks are completed
       for (Todo *child in parent.children) {
           if (!child.isCompleted) {
               allSubtasksCompleted = NO;
               break;
           }
       }
       
       // Update the parent's isCompleted property based on subtasks' completion status
       parent.isCompleted = allSubtasksCompleted;
    
//    BOOL allSubtasksCompleted = [[self flattenChildren:parent.children] valueForKeyPath:@"@sum.isCompleted"] == parent.children.count;
//    if (allSubtasksCompleted) {
//        parent.isCompleted = YES;
//    } else {
//        parent.isCompleted = NO;
//    }
}

- (NSArray<Todo *> *)flattenChildren:(NSArray<Todo *> *)children {
    NSMutableArray<Todo *> *flattenedChildren = [[NSMutableArray alloc] init];
    for (Todo *child in children) {
        [flattenedChildren addObject:child];
        [flattenedChildren addObjectsFromArray:[self flattenChildren:child.children]];
    }
    return [flattenedChildren copy];
}

@end