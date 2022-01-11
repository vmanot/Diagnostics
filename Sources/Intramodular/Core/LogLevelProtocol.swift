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
public enum ClientLogLevel: String, LogLevelProtocol {
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
public enum ServerLogLevel: String, LogLevelProtocol {
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
@available(iOS 15.0, *)
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
