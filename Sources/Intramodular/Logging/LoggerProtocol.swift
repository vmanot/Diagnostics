//
// Copyright (c) Vatsal Manot
//

import Swift

/// A type that can log messages.
public protocol LoggerProtocol: Sendable {
    associatedtype LogLevel: LogLevelProtocol
    associatedtype LogMessage: LogMessageProtocol
    
    func log(
        level: LogLevel,
        _ message: @autoclosure () -> LogMessage,
        metadata: @autoclosure () -> [String: Any]?,
        file: String,
        function: String,
        line: UInt
    )
    
    func log(
        level: LogLevel,
        _ message: @autoclosure () -> String,
        metadata: @autoclosure () -> [String: Any]?,
        file: String,
        function: String,
        line: UInt
    )
    
    func debug(
        _ message: String,
        metadata: [String: Any]?,
        file: String,
        function: String,
        line: UInt
    )
    
    func error(
        _ error: Error,
        metadata: [String: Any]?,
        file: String,
        function: String,
        line: UInt
    )
}

// MARK: - Extensions -

extension LoggerProtocol {
    @_disfavoredOverload
    public func debug(
        _ message: String,
        metadata: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        self.debug(message, metadata: metadata, file: file, function: function, line: line)
    }
    
    @_disfavoredOverload
    public func error(
        _ error: Error,
        metadata: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        self.error(error, metadata: metadata, file: file, function: function, line: line)
    }
}

extension LoggerProtocol where LogLevel: ClientLogLevelProtocol {
    public func debug(
        _ message: @autoclosure () -> String,
        metadata: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        log(
            level: .debug,
            message(),
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )
    }
    
    public func info(
        _ message: @autoclosure () -> String,
        metadata: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        log(
            level: .info,
            message(),
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )
    }
    
    public func warning(
        _ message: @autoclosure () -> String,
        metadata: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        log(
            level: .warning,
            message(),
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )
    }
    
    public func error(
        _ error: String,
        metadata: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        log(
            level: .error,
            error,
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )
    }
    
    public func error(
        _ error: Error,
        metadata: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        log(
            level: .error,
            String(describing: error),
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )
    }
}

extension LoggerProtocol where LogLevel: ServerLogLevelProtocol {
    public func debug(
        _ message: String,
        metadata: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        log(
            level: .debug,
            message,
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )
    }
    
    public func error(
        _ error: Error,
        metadata: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        log(
            level: .error,
            String(describing: error),
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )
    }
}

// MARK: - Implementations -

#if canImport(Logging)
import Logging

extension Logging.Logger: LoggerProtocol, @unchecked Sendable {
    public typealias LogLevel = Logging.Logger.Level
    public typealias LogMessage = Logging.Logger.Message
    
    public func log(
        level: LogLevel,
        _ message: @autoclosure () -> LogMessage,
        metadata: @autoclosure () -> [String : Any]?,
        file: String,
        function: String,
        line: UInt
    ) {
        log(
            level: level,
            message(),
            metadata: metadata()?.mapValues({ Logger.MetadataValue(from: $0) }),
            source: nil,
            file: file,
            function: function,
            line: line
        )
    }
    
    public func log(
        level: LogLevel,
        _ message: @autoclosure () -> String,
        metadata: @autoclosure () -> [String: Any]?,
        file: String,
        function: String,
        line: UInt
    ) {
        log(
            level: level,
            LogMessage("\(message())"),
            metadata: metadata()?.mapValues({ Logger.MetadataValue(from: $0) }),
            file: file,
            function: function,
            line: line
        )
    }
    
    public func debug(
        _ message: String,
        metadata: [String : Any]?,
        file: String,
        function: String,
        line: UInt
    ) {
        self.log(
            level: .debug, .init(message),
            metadata: metadata?.mapValues({ Logger.MetadataValue(from: $0) })
        )
    }
    
    public func error(
        _ error: Error,
        metadata: [String : Any]?,
        file: String,
        function: String,
        line: UInt
    ) {
        self.log(
            level: .error, .init(String(describing: error)),
            metadata: metadata?.mapValues({ Logger.MetadataValue(from: $0) })
        )
    }
}
#endif

#if canImport(OSLog)
import os
import OSLog

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
protocol OSLoggerProtocol {
    func log(level: OSLogType, _ message: OSLogMessage)
}

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
extension os.Logger: LoggerProtocol, OSLoggerProtocol, @unchecked Sendable {
    public typealias LogLevel = OSLogType
    public typealias LogMessage = OSLogMessage
    
    public func log(
        level: LogLevel,
        _ message: @autoclosure () -> LogMessage,
        metadata: @autoclosure () -> [String : Any]?,
        file: String,
        function: String,
        line: UInt
    ) {
        (self as OSLoggerProtocol).log(level: level, message())
    }
    
    public func log(
        level: LogLevel,
        _ message: @autoclosure () -> String,
        metadata: @autoclosure () -> [String : Any]?,
        file: String,
        function: String,
        line: UInt
    ) {
        let message = message()
        
        log(level: level, "\(message, privacy: .auto)")
    }
    
    public func debug(
        _ message: String,
        metadata: [String : Any]?,
        file: String,
        function: String,
        line: UInt
    ) {
        self.log(level: .debug, "\(message, privacy: .auto)")
    }
    
    public func error(
        _ error: Error,
        metadata: [String: Any]?,
        file: String,
        function: String,
        line: UInt
    ) {
        self.log(level: .error, "\(String(describing: error), privacy: .auto)")
    }
}
#endif
