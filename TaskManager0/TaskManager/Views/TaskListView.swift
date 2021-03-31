//
//  ContentView.swift
//  TaskManager
//
//  Created by Yaeji Shin on 2/28/21.
//

import SwiftUI


struct TaskListView: View {
    @ObservedObject var taskListVM = TaskListViewModel()
    
    let tasks = testDataTasks
    
    @State var presentAddNewItem = false
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                List{
                    ForEach(taskListVM.taskCellViewModels){ taskCellVM in
                        TaskCell(taskCellVM: taskCellVM)
                    }
                    if presentAddNewItem{
                        TaskCell(taskCellVM: TaskCellViewModel(task: Task(title:"", completed: false))){
                            task in
                            self.taskListVM.addTask(task: task)
                            self.presentAddNewItem.toggle()
                        }
                    }
                }
                
                Button(action: {self.presentAddNewItem.toggle()}){
                    HStack{
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 20, height:20)
                        Text("Add New Task")
                    }
                }
                .padding()
            }
            .navigationTitle("Tasks")
        }
    }
}


struct HomeView: View {

    var body: some View {
        Color.green.ignoresSafeArea().overlay(
            VStack{
                Text("This is home")
            }
        )
    }
}

struct ContentView: View {

    var body: some View {
        TabView {
            HomeView()
                .tabItem { Text("Home") }
            TaskListView()
                .tabItem { Text("Project") }
        }
    }
}

struct SplashView: View {

    // 1.
       @State var isActive:Bool = false

       var body: some View {
           VStack {
               // 2.
               if self.isActive {
                   // 3.
                   ContentView()
               } else {
                   // 4.
                   Image("productivity")
                    .resizable()
                    .frame(width: 100, height: 100)
                Text("Whatever Pomodoro")
               }
           }
           // 5.
           .onAppear {
               // 6.
               DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                   // 7.
                   withAnimation {
                       self.isActive = true
                   }
               }
           }
       }

}


struct TaskCell: View {
    @ObservedObject var taskCellVM: TaskCellViewModel
    
    var onCommit: (Task) -> (Void) = {_ in }
    
    var body: some View {
        HStack{
            Image(systemName: taskCellVM.task.completed ? "checkmark.circle.fill":"circle")
                .resizable()
                .frame(width: 20, height:20)
                .onTapGesture {
                    self.taskCellVM.task.completed.toggle()
                }
            TextField("Enter the task title", text: $taskCellVM.task.title, onCommit:{
                self.onCommit(self.taskCellVM.task)
            })
        }
    }
}
