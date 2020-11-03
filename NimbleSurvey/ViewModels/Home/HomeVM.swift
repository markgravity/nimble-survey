//
//  HomeVM.swift
//  NimbleSurvey
//
//  Created by Mark G on 01/11/2020.
//

import RxSwift
import SwiftyBase
import Promises
import Burritos
import ObjectMapper

// MARK: - Protocol
protocol HomeVM {
    var items: ValueObservable<[SurveyInfo]> { get }
    var focusIndex: ValueObservable<Int> { get }
    var focusItem: Observable<SurveyInfo?> { get }
    var currentDateText: Observable<String> { get }
    
    func refresh(force: Bool) -> Promise<Void>
    func setFocusIndex(_ index: Int)
}

// MARK: - Implements
class HomeVMImpl: HomeVM {
    @Inject fileprivate var _surveyService: SurveyService
    @Inject fileprivate var _timerService: TimerService
    @Inject fileprivate var _dateService: DateService
    
    fileprivate let _ticked = MutableValue<Void>(())
    fileprivate var _tickTimer: Timer?
    
    /// Cached Items
    static let cachedRawItemsKey = "home_cached_raw_items"
    @UserDefault(HomeVMImpl.cachedRawItemsKey, defaultValue: "", userDefaults: locator.resolve(UserDefaults.self)!)
    fileprivate var _cachedRawItems: String
    
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
        _ticked
            .withUnretained(self)
            .map {
                $0.0._getCurrentDateText()
            }
    }
    
    init() {
        _tick()
    }
    
    deinit {
        _tickTimer?.invalidate()
    }
    
}

// MARK: - Public
extension HomeVMImpl {
    
    /// Ignore cached when refresh
    /// if `force` is `true`
    func refresh(force: Bool) -> Promise<Void> {
        
        Promise(on: .global()) {
            
            let cachedItems = [SurveyInfo].init(JSONString: self._cachedRawItems)
            var items = cachedItems ?? self._items.value
            
            // Force to refresh
            // or no cached items
            if force || cachedItems == nil {
                let params = SurveyListParams(pageNumber: 1, pageSize: 5)
                let list = try await(
                    self._surveyService.list(params: params)
                )
                items = list.items
                
                // Cache them
                self._cachedRawItems = items.toJSONString() ?? ""
            }
            
            
            // Update items
            self._items.accept(items)
            
            // Update focus index
            var focusIndex = self._focusIndex.value
            if focusIndex >= items.count {
                focusIndex = 0
            }
            self._focusIndex.accept(focusIndex)
        }
    }
    
    func setFocusIndex(_ index: Int) {
        _focusIndex.accept(index)
    }
}

// MARK: - Private
fileprivate extension HomeVMImpl {
    
    func _getCurrentDateText() -> String {
        
        let date = _dateService.now()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd"
        return formatter.string(from: date)
            .uppercased()
    }
    
    /// A trigger to refresh
    /// current date text
    func _tick() {
        _ticked.accept(())
        _tickTimer?.invalidate()
        
        // Schedule a next tick
        // at new day
        let nextDate = _dateService.now()
            .addingTimeInterval(86400)
        let startOfNextDay = Calendar.current.startOfDay(for: nextDate)
        let interval = startOfNextDay
            .timeIntervalSince(
                _dateService.now()
            ) + 1
        
        _tickTimer = _timerService.scheduledTimer(
            withTimeInterval: interval,
            repeats: false,
            block: { [weak self] _ in
            self?._tick()
        })
    }
}

// MARK: - State & Enums
