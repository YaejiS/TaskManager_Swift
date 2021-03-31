//
//  TimerManager.swift
//  TaskManager
//
//  Created by Yaeji Shin on 3/28/21.
//

import Foundation
import SwiftUI
import AVFoundation

class TimerManager: ObservableObject {
    @Published var timerMode: TimerMode = .initial
    @Published var secondsLeft = UserDefaults.standard.integer(forKey: "timerLength")
    @Published var onBreak = false
    var startTime = 0
    var timer = Timer()
    
    func setTimerLength(minutes: Int) {
        let defaults = UserDefaults.standard
        defaults.set(minutes, forKey: "timerLength")
        secondsLeft = minutes
        startTime = minutes
    }
    
    func start() {
        timerMode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            if self.secondsLeft == 0 {
                self.reset()
            }
            self.secondsLeft -= 1
        })
    }
    
    func reset() {
        if onBreak == false {
            onBreak = true
            if startTime == 1500 {
                secondsLeft = 300
            } else if startTime == 60 {
                secondsLeft = 5
            } else {
                secondsLeft = 600
            }
//            start()
//            self.timerMode = .running
//            self.secondsLeft = UserDefaults.standard.integer(forKey: "timerLength")
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
//            timer.invalidate()
        } else {
            onBreak = false
            self.timerMode = .initial
            self.secondsLeft = UserDefaults.standard.integer(forKey: "timerLength")
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            timer.invalidate()
        }

    }
    
    func pause() {
        self.timerMode = .paused
        timer.invalidate()
    }
    
//    func timerDidEnd() {
//        if self.secondsLeft <= 0 {
//            timer.invalidate()
//            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
//        }
//    }
}
