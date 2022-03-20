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
    
    func debug(_ message: String, metadata: [String: Any]?)
    func error(_ error: Error, metadata: [String: Any]?)
}

// MARK: - Extensions -

extension LoggerProtocol {
    public func debug(_ message: String, metadata: [String: Any]? = nil) {
        self.debug(message, metadata: metadata)
    }
    
    public func error(_ error: Error, metadata: [String: Any]? = nil) {
        self.error(error, metadata: metadata)
    }
}

// MARK: - Implementations -

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

    public func debug(_ message: String, metadata: [String: Any]?) {
        self.log(level: .debug, .init(message), metadata: metadata?.mapValues({ Logger.MetadataValue(from: $0) }))
    }
    
    public func error(_ error: Error, metadata: [String: Any]?) {
        self.log(level: .error, .init(String(describing: error)), metadata: metadata?.mapValues({ Logger.MetadataValue(from: $0) }))
    }
}

#if canImport(os)

import os

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
    
    public func debug(_ message: String, metadata: [String : Any]?) {
        self.log(level: .debug, "\(message, privacy: .auto)")
    }
    
    public func error(_ error: Error, metadata: [String: Any]?) {
        self.log(level: .error, "\(String(describing: error), privacy: .auto)")
    }
}

#endif

