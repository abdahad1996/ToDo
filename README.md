# ToDo
Recursive Todo with TodoShared Objective C Framework.

💡 My Motivation for this was based on creating single purpose decoupled components following Solid Principles. I think of the design in a critical and scalable way backed by tests which was very fun to do.

### 1. Setup `ToDo` 
- clone the project from the main branch and run the simulator.
### 2. Validate the setup
Test that everything is wired up correctly by running tests to validate that all tests pass.

## Tools
- ✅ Xcode 15.3
- ✅ swift-driver version: 1.90.11.1 Apple Swift version 5.10 (swiftlang-5.10.0.13 clang-1500.3.9.4)

## Frameworks
- ✅ SwiftUI
- ✅ Combine
- ✅ UIKIT
- ✅ No third party

## Concepts
- ✅ MVVM, Clean Architecture
- ✅ Modular Design
- ✅ SOLID Principles
- ✅ TDD, Unit Testing
- ✅ Dependency injection and Dependency Inversion
- ✅ Composition Root, Decorator Patterns, Composite Pattern, Command Query Separation, Adapter Pattern


## Features
- ✅ Adding Root item(s)
- ✅ Editing Root tasks(s)
- ✅ User can add as many “Subtasks” as he/she want.
- ✅ Editing “Subtask” items
- ✅ User can recursively add as many “Subtasks” as he/she want.
- ✅ Bonus – Rearranging Cells
- ✅ Bonus – App persistence


## HIGH LEVEL DIAGRAM
<img width="711" alt="Screenshot 2024-03-27 at 10 26 14 AM" src="https://github.com/abdahad1996/ToDo/assets/28492677/656885c6-e6cb-4e9c-ad47-29dcd98991ea">

This ia high level Diagram which illustrates how we can our business logic into a shared Framework that is consumed by the rest of the app.

## Todo shared Framework
<img width="906" alt="Screenshot 2024-03-27 at 10 55 21 AM" src="https://github.com/abdahad1996/ToDo/assets/28492677/18b208f8-cf87-4076-8c13-83fd9134d3cb">

The domain consists of an entity and usecases 

For the Feature/Domain module here the business logic or model for the feature is written which is completely agnostic of the presentation layer and the data layers(api/cache) . it consists of usecase protocols that our data layer will implement which in this case is our TodoManager

Our data layer TodoManager consists of service implementations of abstractions from the domain layer to achieve dependency Inversion so that data layer depends on the domain.

Infrastructure components live at the boundary of the system. It could be URLSession/Alamofire/Any implemention you prefer in this case i have an In memory Implementation. Frameworks are just plug-ins and we can easily replace them without affecting the rest of the system.

`Todo shared framework encapsulates the above layer and gives us a nice api to work with for the presentation layer`

## UI AND PRESENTATION
Presentation is used for not letting UI to depend directly on Domain. Presentation layer is mainly used for separating UI from domain models (models that have identity, i.e. id property, but UI does not care about that). Thus, Presentation layer simply includes everything UI needs to render (string text and etc).

UI is last piece in the chain and can be swapped easily (since no other layers depend on it). We can easily swap UIKit for SwiftUI without again not affecting the rest of the system as I have already used.

## Composition Root
Composition Root is the most important glue part that bridges communication between domain, services and UI.  Thus, modules stay separated and can be moved to separate frameworks easily if needed. UserFactory just composes the entire object graph, while SceneDelegate uses the static factory to set push the controller to the navigation stack.
