//
//  Todo.h
//  Todo
//
//  Created by macbook abdul on 14/03/2024.
//

#import <Foundation/Foundation.h>
@class Todo;


@interface Todo : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray<Todo *> *children;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, assign) BOOL isCompleted;
@property (nonatomic, copy) NSString *taskNumber;

- (instancetype)initWithName:(NSString *)name
                     children:(NSMutableArray<Todo *> *)children
                        level:(NSInteger)level
                           id:(NSString *)id
                    parentId:(NSString *)parentId
                  isCompleted:(BOOL)isCompleted
                   taskNumber:(NSString *)taskNumber;

- (NSString *)titleLabel;

- (BOOL)isRootTodo;

+ (Todo *)createRootTodoWithName:(NSString *)name rootTaskNumber:(NSInteger)rootTaskNumber;
+ (Todo *)createChildTodoWithName:(NSString *)name parent:(Todo *)parent childTaskNumber:(NSInteger)childTaskNumber;

@end
