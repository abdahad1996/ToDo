//
//  TodoManager+TodoCreator.h
//  TodoShared
//
//  Created by macbook abdul on 14/03/2024.
//

#import <Foundation/Foundation.h>
#import <TodoShared/TodoManager.h>
#import <TodoShared/TodoAdder.h>

 
NS_ASSUME_NONNULL_BEGIN

@interface TodoManager (TodoAdder) <TodoAdder>

@end

NS_ASSUME_NONNULL_END

