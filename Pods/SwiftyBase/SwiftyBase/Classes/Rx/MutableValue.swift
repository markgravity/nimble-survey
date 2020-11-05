//
//  MutableValue.swift
//  Moco360
//
//  Created by Mark G on 3/20/20.
//  Copyright © 2020 Mobiclix. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
import RxSwift
import RxCocoa

public typealias Driver<T> = SharedSequence<DriverSharingStrategy, T>
public class ValueObservable<Element>: ObservableType {
    
    internal let _subject: BehaviorSubject<Element>
    internal let _disposeBag = DisposeBag()
    
    public var value: Element {
        // this try! is ok because subject can't error out or be disposed
        try! self._subject.value()
    }
    
    public init(_ value: Element) {
        self._subject = BehaviorSubject(value: value)
    }
    
    public func on(_ event: Event<Element>) {
        self._subject.on(event)
    }
    
    /// - returns: Canonical interface for push style sequence
    public func asObservable() -> Observable<Element> {
        self._subject.asObservable()
    }
    
    public func subscribe<Observer>(_ observer: Observer)
        -> Disposable where Observer : ObserverType, ValueObservable.Element == Observer.Element {
        _subject.subscribe(observer)
    }
    
    public func map<Result>(_ transform: @escaping (Element) throws -> Result) -> ValueObservable<Result> {
        let subject = MutableValue(try! transform(value))
        subscribe(onNext: {
            subject.accept(try! transform($0))
        })
            .disposed(by: _disposeBag)
        
        return subject
    }
}

public class MutableValue<Element>: ValueObservable<Element> {
    
    /// Accepts `event` and emits it to subscribers
    public func accept(_ event: Element) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?._subject.onNext(event)
            }
            return
        }
        
        self._subject.onNext(event)
    }
    
    public func touch() {
        accept(value)
    }
}

public extension MutableValue where Element == Bool {
    func invert() {
        accept(!value)
    }
}

public extension ObservableType {
    func bind(to value: MutableValue<Element>) -> Disposable {
        bind {
            value.accept($0)
        }
    }
    
    func bind(to value: MutableValue<Element?>) -> Disposable {
        bind {
            value.accept($0)
        }
    }
}
