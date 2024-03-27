//
//  TodoShared.h
//  TodoShared
//
//  Created by macbook abdul on 14/03/2024.
//

#import <Foundation/Foundation.h>

//model
#import <TodoShared/todo.h>

//Usecases
#import <TodoShared/TodoLoader.h>
#import <TodoShared/TodoAdder.h>
#import <TodoShared/TodoDeleter.h>
#import <TodoShared/TodoNameUpdater.h>
#import <TodoShared/TodoStatusUpdater.h>
#import <TodoShared/TodoMover.h>

 

//implementations
#import <TodoShared/TodoManager.h>
#import <TodoShared/TodoManager+TodoCreator.h>
#import <TodoShared/TodoManager+TodoLoader.h>
#import <TodoShared/TodoManager+TodoDeleter.h>
#import <TodoShared/TodoManager+TodoNameUpdater.h>
#import <TodoShared/TodoManager+TodoStatusUpdater.h>
#import <TodoShared/TodoManager+TodoMover.h>



 

//! Project version number for TodoShared.
FOUNDATION_EXPORT double TodoSharedVersionNumber;

//! Project version string for TodoShared.
FOUNDATION_EXPORT const unsigned char TodoSharedVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <TodoShared/PublicHeader.h>


