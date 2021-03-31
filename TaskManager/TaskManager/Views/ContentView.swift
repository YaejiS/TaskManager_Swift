//
//  ContentView.swift
//  TaskManager
//
//  Created by Yaeji Shin on 3/28/21.
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
    @ObservedObject var timerManager = TimerManager()
    @ObservedObject var taskListVM = TaskListViewModel()
    
    @State var taskPickerIndex = 0
    @State var selectedPickerIndex = 0
    
    let availableMinutes = [1,25,50]
    let onBreak = false
    
    var body: some View {
//        NavigationView {
            Color.yellow.opacity(0.2).ignoresSafeArea().overlay(
                VStack(spacing: 0){
                    if timerManager.onBreak {
                        Text("Break Time").bold().font(.system(size: 20)).padding(.top, 70)
                    } else {
                        Text("Pomodoro Time").bold().font(.system(size: 20)).padding(.top, 70)
                    }
                    
                    Text("\(secondsToMinutesAndSeconds(seconds: timerManager.secondsLeft))")
                        .font(.system(size: 90))
                        
                    Image(systemName: timerManager.timerMode == .running ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .foregroundColor(.red)
                        .background(Color.white)
                        .onTapGesture(perform: {
                            if self.timerManager.timerMode == .initial {
                                self.timerManager.setTimerLength(minutes: self.availableMinutes[self.selectedPickerIndex]*60)
                            }
                            self.timerManager.timerMode == .running ? self.timerManager.pause() : self.timerManager.start()
                        })
                    if timerManager.timerMode == .paused {
                        Image(systemName: "gobackward")
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
//                            .padding(.top, 20)
                            .onTapGesture(perform: {
                                self.timerManager.reset()
                            })
                    }
                    
                    if timerManager.timerMode == .initial {
                        Picker(selection: $selectedPickerIndex, label: Text("")) {
                            ForEach(0 ..< availableMinutes.count) {
                                if self.availableMinutes[$0] == 25 {
                                    Text("\(self.availableMinutes[$0]) min : 5 min")
                                } else if self.availableMinutes[$0] == 1 {
                                    Text("\(self.availableMinutes[$0]) min : 5 seconds")
                                } else {
                                    Text("\(self.availableMinutes[$0]) min : 10 min")
                                }

                            }
                        }.scaledToFit()
                        Picker(selection: $taskPickerIndex, label: Text("")) {
                            ForEach(self.taskListVM.taskCellViewModels){ taskCellVM in
                                Text(taskCellVM.task.title)
                            }
                        }.scaledToFit()

                    }
                    Spacer()
                }
            )
//            .navigationBarTitle("Pomodoro").padding(.top, 0)
//        }
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
