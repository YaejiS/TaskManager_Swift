//
//  ContentView.swift
//  TaskManager
//
//  Created by Yaeji Shin on 2/28/21.
//

import SwiftUI

struct SplashView: View {
    @State var isActive:Bool = false
    
    var body: some View {
        VStack {
            if self.isActive {
                ContentView()
                
            } else {
                Text("Task Manager")
                    .font(Font.largeTitle)
                Image("").resizable().frame(width: 100, height: 100)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
    
}

struct HomeView: View {
    var body: some View {
        Color(red: 242 / 255, green: 242 / 255, blue: 5 / 255).opacity(0.2)
            .ignoresSafeArea()
            .overlay(
                VStack {
                    Text("Main Screen")
                    Image(systemName: "square.and.pencil")
                }
            )
    }
}

//struct

struct TaskListView: View {
//struct HomeView: View {
    @ObservedObject var taskListVM = TaskListViewModel()
    
    @State var presentAddNewItem = false
//    @State var showSettingsScreen = false
    
    let tasks = testDataTasks
    
    var body: some View {
        
        Color(red: 242 / 255, green: 242 / 255, blue: 5 / 255).opacity(0.2)
            .ignoresSafeArea()
            .overlay(
                ZStack {

                }
            )
        
        NavigationView {
            VStack(alignment: .leading){
                List {
                    ForEach(taskListVM.taskCellViewModels) { taskCellVM in
                        TaskCell(taskCellVM: taskCellVM)
                    }
                }
                if presentAddNewItem {
                    TaskCell(taskCellVM: TaskCellViewModel(task: Task(title: "", completed: false)))
                    { task in
                        self.taskListVM.addTask(task: task)
                        self.presentAddNewItem.toggle()
                    }
                }
                Button(action: { self.presentAddNewItem.toggle()   }) {
                    HStack {
                        Image(systemName: "plus.circle.fill").resizable().frame(width: 20, height: 20)
                        Text("Add New Task")
                    }
                }
                .padding()
            }
            .navigationBarTitle("Tasks")
        }
    }
}


struct ContentView: View {
    var body: some View {
        TabView {
            HomeView().tabItem {
                Text("Home")
            }
            TaskListView().tabItem {
                Text("Tasks")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}

struct TaskCell: View {
    @ObservedObject var taskCellVM: TaskCellViewModel
    
    var onCommit: (Task) -> (Void) = { _ in }
    var body: some View {
        HStack {
            Image(systemName: taskCellVM.task.completed ? "checkmark.circle.fill" : "circle")
                .resizable().frame(width: 20, height: 20)
                .onTapGesture {
                    self.taskCellVM.task.completed.toggle()
                }
            TextField("Enter new task", text: $taskCellVM.task.title, onCommit: {
                self.onCommit(self.taskCellVM.task)
            })
        }
    }
}
