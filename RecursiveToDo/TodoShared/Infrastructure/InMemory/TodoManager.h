//
//  TodoManager.h
//  TodoShared
//
//  Created by macbook abdul on 14/03/2024.
//

#import <Foundation/Foundation.h>
#import <TodoShared/TodoAdder.h>

@class Todo;


@interface TodoManager : NSObject

@property(nonatomic, strong) NSMutableArray<Todo *> *todos;

- (NSArray<Todo *> *)flattenTodos;
- (Todo *)findNearestParentForId:(NSString *)parentId;
- (void)markAllCompletedParentsStatusToIncompleteOnAdditionOfNewSubtaskForId:(NSString *)parentId;
- (void)iterateOverEachParentAndCheckStatusUntilRootForId:(NSString *)parentId;
- (void)toggleStatusOfAnyParentAndAllChildren:(Todo *)parent;
- (NSArray<Todo *> *)flattenChildren:(NSArray<Todo *> *)children;
- (void)deleteNodeAndChildren:(Todo *)node fromArray:(NSMutableArray<Todo *> *)todos;
@end


