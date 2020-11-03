//
//  TimerService.swift
//  NimbleSurvey
//
//  Created by Mark G on 01/11/2020.
//

import Foundation

// MARK: - Protocol
protocol TimerService {
    func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> Timer
}

// MARK: Implements
class TimerServiceImpl: TimerService {
    
    func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> Timer {
        Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats, block: block)
    }
}
