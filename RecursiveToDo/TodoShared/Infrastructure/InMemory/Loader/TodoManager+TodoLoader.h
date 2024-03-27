//
//  TodoManager+TodoLoader.h
//  TodoShared
//
//  Created by macbook abdul on 14/03/2024.
//

#import <Foundation/Foundation.h>

@class TodoManager;
 
#import <TodoShared/TodoLoader.h>

 
NS_ASSUME_NONNULL_BEGIN

@interface TodoManager (TodoLoader) <TodoLoader>

@end

NS_ASSUME_NONNULL_END
