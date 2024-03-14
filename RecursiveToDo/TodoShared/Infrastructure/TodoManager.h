//
//  TodoManager.h
//  TodoShared
//
//  Created by macbook abdul on 14/03/2024.
//

#import <Foundation/Foundation.h>

@class Todo;


@interface TodoManager : NSObject

@property(nonatomic, strong) NSMutableArray<Todo *> *todos;

- (NSArray<Todo *> *)flattenTodos;
- (Todo *)findNearestParentForId:(NSString *)parentId;
- (void)markAllCompletedParentsStatusToIncompleteOnAdditionOfNewSubtaskForId:(NSString *)parentId;
- (void)iterateOverEachParentAndCheckStatusUntilRootForId:(NSString *)parentId;
- (void)toggleStatusOfParent:(Todo *)parent;
- (NSArray<Todo *> *)flattenChildren:(NSArray<Todo *> *)children;
@end


