//
//  Tests.swift
//  Tests
//
//  Created by Mark G on 3/25/20.
//  Copyright © 2020 Mobiclix. All rights reserved.
//

@testable import NimbleSurvey
import XCTest
import Mockingbird
import Swinject
import Nimble
import RxSwift
import Promises
import SwiftyBase

// MARK - Locator
extension Container {
    func mock<Service>(_ serviceType: Service.Type,_ service: Service) {
        locator.register(serviceType) { _ in service }
    }
}

func waitUntil(
    on queue: DispatchQueue = .global(),
    timeout: TimeInterval = AsyncDefaults.Timeout,
    file: FileString = #file,
    line: UInt = #line,
    action: (@escaping () throws -> Void)) {
    
    waitUntil(timeout: timeout, file: file, line: line) { done in
        queue.async {
            try! action()
            
            done()
        }
    }
}
// MARK: - Nimble
let anError = NSError(domain: "empty", code: -1, userInfo: nil)

func inOrder<T: Equatable>(_ expectedValues: T...) -> Predicate<[T]> {
    return equal(expectedValues)
}


extension Expectation where T: ObservableType, T.Element: Equatable {
    
    @discardableResult
    func emits(
        _ expectedValue: T.Element,
        timeout: TimeInterval = AsyncDefaults.Timeout,
        pending: Bool = false,
        pollInterval: TimeInterval = AsyncDefaults.PollInterval,
        description: String? = nil) -> Emits<T> {
        
        
        emits(
            equal(expectedValue),
            timeout: timeout,
            pollInterval: pollInterval,
            pending: pending,
            description: description
        )
    }
    
    @discardableResult
    func emits(
        _ predicate: Predicate<T.Element>,
        timeout: TimeInterval = AsyncDefaults.Timeout,
        pollInterval: TimeInterval = AsyncDefaults.PollInterval,
        pending: Bool = false,
        description: String? = nil) -> Emits<T> {
        
        let observable = (try! expression.evaluate())!
        
        
        // Pending verify
        if !pending {
            var value: T.Element?
            let onNext: (_ value: T.Element) -> Void = {
                value = $0
            }
            
            _ = observable
                .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .bind(onNext: onNext)
            
            expect(value,
                   file: expression.location.file,
                   line: expression.location.line
            ).toEventually(
                predicate,
                timeout: timeout,
                pollInterval: pollInterval,
                description: description
            )
        }
        
        
        return SingleEmits(
            observable: observable,
            predicate: predicate,
            location: expression.location,
            timeout: timeout,
            pollInterval: pollInterval
        )
    }
    
    @discardableResult
    func emits(
        _ predicate: Predicate<[T.Element]>,
        timeout: TimeInterval = AsyncDefaults.Timeout,
        pollInterval: TimeInterval = AsyncDefaults.PollInterval,
        pending: Bool = false,
        description: String? = nil) -> Emits<T> {
        
        let observable = (try! expression.evaluate())!
        
        var values = [T.Element]()
        
        // Pending verify
        if !pending {
            let onNext: (_ value: T.Element) -> Void = {
                values.append($0)
            }
            
            _ = observable
                .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .bind(onNext: onNext)
            
            expect(values,
                   file: expression.location.file,
                   line: expression.location.line
            ).toEventually(
                predicate,
                timeout: timeout,
                pollInterval: pollInterval,
                description: description
            )
        }
        
        
        return Emits(
            observable: observable,
            predicate: predicate,
            location: expression.location,
            timeout: timeout,
            pollInterval: pollInterval
        )
    }
}


class Emits<O: ObservableType> {
    fileprivate var _events = [O.Element]()
    fileprivate let _observable: O
    fileprivate let _location: Nimble.SourceLocation
    fileprivate let _timeout: TimeInterval
    fileprivate let _pollInterval: TimeInterval
    fileprivate let _predicate: Predicate<[O.Element]>?
    
    init(
        observable: O,
        predicate: Predicate<[O.Element]>?,
        location: Nimble.SourceLocation,
        timeout: TimeInterval = AsyncDefaults.Timeout,
        pollInterval: TimeInterval = AsyncDefaults.PollInterval
    ) {
        _observable = observable
        _location = location
        _timeout = timeout
        _pollInterval = pollInterval
        _predicate = predicate
    }
    
    func subscribe() {
        let onNext: (_ value: O.Element) -> Void = { [weak self] in
            
            self?._events.append($0)
        }
        
        _ = _observable
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(onNext: onNext)
    }
    
    func verify() {
        expect(self._events,
               file: _location.file,
               line: _location.line
        ).toEventually(
            _predicate!,
            timeout: _timeout,
            pollInterval: _pollInterval,
            description: nil
        )

    }
}

class SingleEmits<O: ObservableType> : Emits<O> {
    fileprivate let _singlePredicate: Predicate<O.Element>
    
    init(
        observable: O,
        predicate: Predicate<O.Element>,
        location: Nimble.SourceLocation,
        timeout: TimeInterval = AsyncDefaults.Timeout,
        pollInterval: TimeInterval = AsyncDefaults.PollInterval
    ) {
        
        _singlePredicate = predicate
        super.init(
            observable: observable,
            predicate: nil,
            location: location,
            timeout: timeout,
            pollInterval: pollInterval
        )
    }
    
    
    override
    func verify() {
        expect(self._events.first,
               file: _location.file,
               line: _location.line
        ).toEventually(
            _singlePredicate,
            timeout: _timeout,
            pollInterval: _pollInterval,
            description: nil
        )
        
    }
}

@_functionBuilder
struct GroupEmitsBuilder {
    static func buildBlock<T1: ObservableType, T2: ObservableType>(_ e1: Emits<T1>, _ e2: Emits<T2>) {
        e1.subscribe()
        e2.subscribe()
        
        e1.verify()
        e2.verify()
    }
    
    static func buildBlock<T1: ObservableType, T2: ObservableType, T3: ObservableType>(
        _ e1: Emits<T1>,
        _ e2: Emits<T2>,
        _ e3: Emits<T3>) {
        
        e1.subscribe()
        e2.subscribe()
        e3.subscribe()
        
        e1.verify()
        e2.verify()
        e3.verify()
    }
    
    static func buildBlock<T1: ObservableType, T2: ObservableType, T3: ObservableType, T4: ObservableType>(
        _ e1: Emits<T1>,
        _ e2: Emits<T2>,
        _ e3: Emits<T3>,
        _ e4: Emits<T4>) {
        
        e1.subscribe()
        e2.subscribe()
        e3.subscribe()
        e4.subscribe()
        
        e1.verify()
        e2.verify()
        e3.verify()
        e4.verify()
    }
    
    static func buildBlock<
        T1: ObservableType,
        T2: ObservableType,
        T3: ObservableType,
        T4: ObservableType,
        T5: ObservableType
        >(
        _ e1: Emits<T1>,
        _ e2: Emits<T2>,
        _ e3: Emits<T3>,
        _ e4: Emits<T4>,
        _ e5: Emits<T5>
    ) {
        
        e1.subscribe()
        e2.subscribe()
        e3.subscribe()
        e4.subscribe()
        e5.subscribe()
        
        e1.verify()
        e2.verify()
        e3.verify()
        e4.verify()
        e5.verify()
    }
    
    static func buildBlock<
        T1: ObservableType,
        T2: ObservableType,
        T3: ObservableType,
        T4: ObservableType,
        T5: ObservableType,
        T6: ObservableType,
        T7: ObservableType
        >(
        _ e1: Emits<T1>,
        _ e2: Emits<T2>,
        _ e3: Emits<T3>,
        _ e4: Emits<T4>,
        _ e5: Emits<T5>,
        _ e6: Emits<T6>,
        _ e7: Emits<T7>
    ) {
        
        e1.subscribe()
        e2.subscribe()
        e3.subscribe()
        e4.subscribe()
        e5.subscribe()
        e6.subscribe()
        e7.subscribe()
        
        e1.verify()
        e2.verify()
        e3.verify()
        e4.verify()
        e5.verify()
        e6.verify()
        e7.verify()
    }
    
    static func buildBlock<
        T1: ObservableType,
        T2: ObservableType,
        T3: ObservableType,
        T4: ObservableType,
        T5: ObservableType,
        T6: ObservableType,
        T7: ObservableType,
        T8: ObservableType
        >(
        _ e1: Emits<T1>,
        _ e2: Emits<T2>,
        _ e3: Emits<T3>,
        _ e4: Emits<T4>,
        _ e5: Emits<T5>,
        _ e6: Emits<T6>,
        _ e7: Emits<T7>,
        _ e8: Emits<T8>
    ) {
        
        e1.subscribe()
        e2.subscribe()
        e3.subscribe()
        e4.subscribe()
        e5.subscribe()
        e6.subscribe()
        e7.subscribe()
        e8.subscribe()
        
        e1.verify()
        e2.verify()
        e3.verify()
        e4.verify()
        e5.verify()
        e6.verify()
        e7.verify()
        e8.verify()
    }
    
    static func buildBlock<
        T1: ObservableType,
        T2: ObservableType,
        T3: ObservableType,
        T4: ObservableType,
        T5: ObservableType,
        T6: ObservableType,
        T7: ObservableType,
        T8: ObservableType,
        T9: ObservableType,
        T10: ObservableType
        >(
        _ e1: Emits<T1>,
        _ e2: Emits<T2>,
        _ e3: Emits<T3>,
        _ e4: Emits<T4>,
        _ e5: Emits<T5>,
        _ e6: Emits<T6>,
        _ e7: Emits<T7>,
        _ e8: Emits<T8>,
        _ e9: Emits<T9>,
        _ e10: Emits<T10>
    ) {
        
        e1.subscribe()
        e2.subscribe()
        e3.subscribe()
        e4.subscribe()
        e5.subscribe()
        e6.subscribe()
        e7.subscribe()
        e8.subscribe()
        e9.subscribe()
        e10.subscribe()
        
        e1.verify()
        e2.verify()
        e3.verify()
        e4.verify()
        e5.verify()
        e6.verify()
        e7.verify()
        e8.verify()
        e9.verify()
        e10.verify()
    }

}

func group(@GroupEmitsBuilder _ content: () -> Void) {
    content()
}


func group<T1: ObservableType, T2: ObservableType>(_ e1: Emits<T1>, _ e2: Emits<T2>) {
    e1.subscribe()
    e2.subscribe()
    
    e1.verify()
    e2.verify()
}

func group<T1: ObservableType, T2: ObservableType, T3: ObservableType>(_ e1: Emits<T1>, _ e2: Emits<T2>,  _ e3: Emits<T3>) {
    e1.subscribe()
    e2.subscribe()
    e3.subscribe()
    
    e1.verify()
    e2.verify()
    e3.verify()
}

func group<T1: ObservableType, T2: ObservableType, T3: ObservableType, T4: ObservableType>(_ e1: Emits<T1>, _ e2: Emits<T2>,  _ e3: Emits<T3>, _ e4: Emits<T4>) {
    e1.subscribe()
    e2.subscribe()
    e3.subscribe()
    e4.subscribe()
    
    e1.verify()
    e2.verify()
    e3.verify()
    e4.verify()
}

//func delay(_ duration: Duration = .init(miliseconds: 100), action: (() -> Void)? = nil) {
//    guard let action = action else {
//        sleep(UInt32(duration.inSeconds))
//        return
//    }
//    
//    let interval = DispatchTimeInterval.milliseconds(duration.inMilliseconds)
//    let deadline = DispatchTime.now().advanced(by: interval)
//    DispatchQueue.main.asyncAfter(deadline: deadline) {
//        action()
//    }
//}

// MARK: - Fixture
//func fixture(_ name: String) -> String {
//    let bundle = Bundle(for: FakeRoomInfo.self)
//    let path = bundle.path(forResource: name, ofType: "json")!
//    return try! String(contentsOf: URL(fileURLWithPath: path))
//}
