//
//  TodoManager+TodoLoader.h
//  TodoShared
//
//  Created by macbook abdul on 14/03/2024.
//

#import <Foundation/Foundation.h>

@class TodoManager;
 
#import <TodoShared/TodoMover.h>

 
NS_ASSUME_NONNULL_BEGIN

@interface TodoManager (TodoMover) <TodoMover>

@end

NS_ASSUME_NONNULL_END

