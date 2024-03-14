//
//  Todo.m
//  TodoShared
//
//  Created by macbook abdul on 14/03/2024.
//

#import <Foundation/Foundation.h>
#import "Todo.h"

@implementation Todo

- (instancetype)initWithName:(NSString *)name
                     children:(NSMutableArray<Todo *> *)children
                        level:(NSInteger)level
                           id:(NSString *)ID
                    parentId:(NSString *)parentID
                  isCompleted:(BOOL)isCompleted
                   taskNumber:(NSString *)taskNumber {
    self = [super init];
    if (self) {
        _name = [name copy];
        _children = [children mutableCopy];
        _level = level;
        _id = [ID copy];
        _parentId = [parentID copy];
        _isCompleted = isCompleted;
        _taskNumber = [taskNumber copy];
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }

    if (![object isKindOfClass:[Todo class]]) {
        return NO;
    }

    Todo *otherTodo = (Todo *)object;
    return [self.id isEqualToString:otherTodo.id];
}

- (NSString *)titleLabel {
    if ([self isRootTodo]) {
        return [NSString stringWithFormat:@"Root %@ - %@", self.taskNumber, self.name];
    } else {
        return [NSString stringWithFormat:@"Child %@ - %@", self.taskNumber, self.name];
    }
}

- (BOOL)isRootTodo {
    return (self.parentId == nil);
}

+ (Todo *)createRootTodoWithName:(NSString *)name rootTaskNumber:(NSInteger)rootTaskNumber {
    NSString *taskNumber = [NSString stringWithFormat:@"%ld", (long)rootTaskNumber];
    return [[Todo alloc] initWithName:name
                              children:[[NSMutableArray alloc] init]
                                 level:0
                                    id:[[NSUUID UUID] UUIDString]
                             parentId:nil
                           isCompleted:NO
                            taskNumber:taskNumber];
}

+ (Todo *)createChildTodoWithName:(NSString *)name parent:(Todo *)parent childTaskNumber:(NSInteger)childTaskNumber {
    NSString *taskNumber = [NSString stringWithFormat:@"%@.%ld", parent.taskNumber, (long)childTaskNumber];
    return [[Todo alloc] initWithName:name
                              children:[[NSMutableArray alloc] init]
                                 level:(parent.level + 1)
                                    id:[[NSUUID UUID] UUIDString]
                             parentId:parent.id
                           isCompleted:NO
                            taskNumber:taskNumber];
}

@end
