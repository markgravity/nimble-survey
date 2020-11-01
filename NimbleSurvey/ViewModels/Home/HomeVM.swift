//
//  HomeVM.swift
//  NimbleSurvey
//
//  Created by Mark G on 01/11/2020.
//

import RxSwift
import SwiftyBase
import Promises

// MARK: - Protocol
protocol HomeVM {
    var items: ValueObservable<[SurveyInfo]> { get }
    var focusIndex: ValueObservable<Int> { get }
    var focusItem: Observable<SurveyInfo?> { get }
    var currentDateText: Observable<String> { get }
    
    func refresh() -> Promise<Void>
    func tick()
    func setFocusIndex(_ index: Int)
}

// MARK: - Implements
class HomeVMImpl: HomeVM {
    @Inject fileprivate var _surveyService: SurveyService
    fileprivate let _tick = PublishSubject<Void>()
    
    /// Items
    fileprivate let _items = MutableValue<[SurveyInfo]>([])
    var items: ValueObservable<[SurveyInfo]> {
        _items
    }
    
    /// Focus Index
    fileprivate let _focusIndex = MutableValue<Int>(0)
    var focusIndex: ValueObservable<Int> {
        _focusIndex
    }
    
    /// Focus Item
    var focusItem: Observable<SurveyInfo?> {
        _focusIndex
            .withUnretained(self)
            .map { `self`, index in
                
                let items = self.items.value
                guard index < items.count
                else { return nil }

                return items[index]
            }
    }
    
    /// Current Date Text
    var currentDateText: Observable<String> {
        _tick
            .withUnretained(self)
            .map {
                $0.0._getCurrentDateText()
            }
    }
    
}

// MARK: - Public
extension HomeVMImpl {
    
    func refresh() -> Promise<Void> {
        
        Promise(on: .global()) {
            let params = SurveyListParams(pageNumber: 1, pageSize: 5)
            let list = try await(
                self._surveyService.list(params: params)
            )
            self._items.accept(list.items)
            self._focusIndex.accept(0)
            self.tick()
        }
    }
    
    /// A trigger to refresh
    /// current date text
    func tick() {
        _tick.onNext(())
    }
    
    func setFocusIndex(_ index: Int) {
        _focusIndex.accept(index)
    }
}

// MARK: - Private
fileprivate extension HomeVMImpl {
    
    func _getCurrentDateText() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd"
        return formatter.string(from: Date()).uppercased()
    }
}

// MARK: - State & Enums
