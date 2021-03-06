//
// Copyright (c) Vatsal Manot
//

#if canImport(Logging)
import Logging
#endif
#if canImport(os)
import os.log
#endif
#if canImport(OSLog)
import OSLog
#endif
import Swallow
import Swift

public protocol LogLevelProtocol: StringConvertible {
    
}

public protocol ClientLogLevelProtocol: LogLevelProtocol {
    static var undefined: Self { get }
    static var debug: Self { get }
    static var info: Self { get }
    static var notice: Self { get }
    static var error: Self { get }
    static var fault: Self { get }
}

public protocol ServerLogLevelProtocol: LogLevelProtocol {
    static var trace: Self { get }
    static var debug: Self { get }
    static var info: Self { get }
    static var notice: Self { get }
    static var warning: Self { get }
    static var error: Self { get }
    static var critical: Self { get }
}

// MARK: - Implementations -

public enum AnyLogLevel: String, LogLevelProtocol {
    case undefined
    case trace
    case debug
    case info
    case notice
    case warning
    case error
    case fault
    case critical
    
    public var stringValue: String {
        rawValue
    }
}

/// A log-level type suitable for client applications.
public enum ClientLogLevel: String, ClientLogLevelProtocol {
    case undefined
    case debug
    case info
    case notice
    case error
    case fault
    
    public var stringValue: String {
        rawValue
    }
}

/// A log-level type suitable for server applications.
public enum ServerLogLevel: String, ServerLogLevelProtocol {
    case trace
    case debug
    case info
    case notice
    case warning
    case error
    case critical
    
    public var stringValue: String {
        rawValue
    }
}

#if canImport(Logging)
extension Logging.Logger.Level: LogLevelProtocol {
    public var stringValue: String {
        switch self {
            case .trace:
                return "trace"
            case .debug:
                return "debug"
            case .info:
                return "info"
            case .notice:
                return "notice"
            case .warning:
                return "warning"
            case .error:
                return "error"
            case .critical:
                return "critical"
        }
    }
}
#endif

#if canImport(os)
extension os.OSLogType: LogLevelProtocol {
    public var stringValue: String {
        switch self {
            case .debug:
                return "debug"
            case .info:
                return "info"
            case .error:
                return "error"
            case .fault:
                return "fault"
            default:
                return "unknown"
        }
    }
}
#endif

#if canImport(OSLog)
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension OSLogEntryLog.Level: LogLevelProtocol {
    public var stringValue: String {
        switch self {
            case .undefined:
                return "undefined"
            case .debug:
                return "debug"
            case .info:
                return "info"
            case .notice:
                return "notice"
            case .error:
                return "error"
            case .fault:
                return "fault"
            @unknown default:
                return "unknown"
        }
    }
}
#endif
