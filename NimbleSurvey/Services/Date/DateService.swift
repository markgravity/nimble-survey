//
//  DateService.swift
//  NimbleSurvey
//
//  Created by Mark G on 01/11/2020.
//

import Foundation

// MARK: - Protocol
protocol DateService {
    func now() -> Date
}

// MARK: Implements
class DateServiceImpl: DateService {
    func now() -> Date {
        Date()
    }
}
