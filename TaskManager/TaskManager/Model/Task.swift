//
//  Task.swift
//  TaskManager
//
//  Created by Yaeji Shin on 3/28/21.
//

import Foundation

struct Task: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var completed: Bool
}

#if DEBUG
let testDataTasks = [
    Task(title: "task1", completed: true),
    Task(title: "task2", completed: false),
    Task(title: "task3", completed: false),

]
#endif
