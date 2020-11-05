
public func fakeDuration(elapse: Duration, _ actions: () -> Void) {
    Duration.fakeElapseDuration = elapse
    actions()
    Duration.fakeElapseDuration = Duration(miliseconds: 0)
}

public struct Duration {
    fileprivate static var fakeElapseDuration = Duration(miliseconds: 0)
    
    fileprivate let _milliseconds: Int
    public var inMilliseconds: Int {
        return _milliseconds - Self.fakeElapseDuration._milliseconds
    }
    
    public var inSeconds: Int {
        return inMilliseconds / 1000
    }
    
    public var inTimeInterval: TimeInterval {
        return TimeInterval(inMilliseconds) / 1000.0
    }
    
    public var inMinutes: Int {
        return inMilliseconds / 60000
    }
    
    public var inHours: Int {
        return inMilliseconds / 3600000
    }
    
    public var inDays: Int {
        return inMilliseconds / 86400000
    }
    
    public init(milliseconds: Int) {
        _milliseconds = milliseconds
    }
    
    public init(miliseconds: Int) {
        self.init(milliseconds: miliseconds)
    }
    
    public init(seconds: Int) {
        self.init(miliseconds: seconds * 1000)
    }
    
    public init(minutes: Int) {
        self.init(miliseconds: minutes * 60000)
    }
    
    public init(hours: Int) {
        self.init(miliseconds: hours * 3600000)
    }
    
    public init(days: Int) {
        self.init(miliseconds: days * 86400000)
    }
    
    
    public static func + (left: Duration, right: Duration) -> Duration {
        Duration(miliseconds: left.inMilliseconds + right.inMilliseconds)
    }
    
    public static func - (left: Duration, right: Duration) -> Duration {
        Duration(miliseconds: left.inMilliseconds - right.inMilliseconds)
    }
}

//public func +=(lhs: Duration, rhs: Duration) -> Void {
//    lhs = lhs
//}

extension Duration: Equatable {}

// MARK: - Convenience
public extension Duration {
    static func milliseconds(_ miliseconds: Int) -> Duration {
        Duration(miliseconds: miliseconds)
    }
    static func seconds(_ seconds: Int) -> Duration { Duration(seconds: seconds) }
    static func minutes(_ minutes: Int) -> Duration { Duration(minutes: minutes) }
    static func hours(_ hours: Int) -> Duration { Duration(hours: hours) }
    static func days(_ days: Int) -> Duration { Duration(days: days) }
    
    static var zero: Duration { .milliseconds(0)  }
}


public enum DurationUnit {
    case milliseconds, seconds, minutes, hours, days
}
