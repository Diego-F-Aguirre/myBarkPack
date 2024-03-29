//
//  TaskController.swift
//  MyBarkPack
//
//  Created by Diego Aguirre on 4/24/16.
//  Copyright © 2016 home. All rights reserved.
//

import Foundation
import CoreData

class TaskController {
    static let sharedController = TaskController()
    private let kTask = "Task"
    
    var dog: Dog?
    
    var tasks: [Task] {
        guard let dog = dog,
            tasks = fetchAllTasksForDog(dog) else { return [] }
        return tasks
    }
}

extension TaskController {
    func createTask(title: String, dog: Dog, type: Type, isComplete: Bool) {
        let task = Task(title: title, type: type, isComplete: isComplete)
        
        task?.dog = dog
        
        saveTask()
    }
    
    func fetchAllTasksForDog(dog: Dog) -> [Task]? {
        let request = NSFetchRequest(entityName: kTask)
        
        var tasks: [Task] = []
        
        do {
            tasks = try dog.managedObjectContext?.executeFetchRequest(request) as! [Task]
        } catch let error as NSError {
            print("failed \(error.localizedDescription) in \(#function)")
            return nil
        }
        return tasks
    }
    
    func saveTask() {
        let context = Stack.sharedStack.managedObjectContext
        
        do {
            let _ = try context.save()
        } catch let error as NSError {
            print("failed \(error.localizedDescription) in \(#function)")
        }
    }
    
    func deleteTask(task:Task) {
        task.managedObjectContext?.deleteObject(task)
        saveTask()
    }
    
    func updateCheckValueChanged(task: Task, selected: Bool) {
        task.isChecked = !task.isChecked.boolValue
        saveTask()
    }
}