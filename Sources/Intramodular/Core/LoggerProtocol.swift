//
// Copyright (c) Vatsal Manot
//

import Swift

/// A type that can log messages.
public protocol LoggerProtocol {
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
    
    func debug(_ message: String, metadata: [String: Any]?)
    func notice(_ message: String, metadata: [String: Any]?)
    func error(_ error: Error, metadata: [String: Any]?)
}

// MARK: - Extensions -

extension LoggerProtocol {
    public func notice(_ message: String, metadata: [String: Any]? = nil) {
        self.notice(message, metadata: nil)
    }
    
    public func debug(_ message: String, metadata: [String: Any]? = nil) {
        self.debug(message, metadata: nil)
    }
    
    public func error(_ error: Error, metadata: [String: Any]? = nil) {
        self.error(error, metadata: nil)
    }
}

// MARK: - Implementations -

extension Logging.Logger: LoggerProtocol {
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
        
    }
    
    public func notice(_ message: String, metadata: [String: Any]?) {
        self.log(level: .notice, .init(message), metadata: metadata?.mapValues({ Logger.MetadataValue(from: $0) }))
    }
    
    public func debug(_ message: String, metadata: [String: Any]?) {
        self.log(level: .debug, .init(message), metadata: metadata?.mapValues({ Logger.MetadataValue(from: $0) }))
    }
    
    public func error(_ error: Error, metadata: [String: Any]?) {
        self.log(level: .error, .init(String(describing: error)), metadata: metadata?.mapValues({ Logger.MetadataValue(from: $0) }))
    }
}

// TODO: Improve implementation
extension TextDump: LoggerProtocol {
    public typealias LogLevel = AnyLogLevel
    public typealias LogMessage = Logging.Logger.Message
    
    public func log(
        level: LogLevel,
        _ message: @autoclosure () -> LogMessage,
        metadata: @autoclosure () -> [String : Any]?,
        file: String,
        function: String,
        line: UInt
    ) {
        
    }
    
    public func debug(_ message: String, metadata: [String: Any]?) {
        lines.append("[DEBUG] \(message)")
    }
    
    public func notice(_ message: String, metadata: [String: Any]?) {
        lines.append("[NOTICE] \(message)")
    }
    
    public func error(_ error: Error, metadata: [String: Any]?) {
        lines.append("[ERROR] \(error)")
    }
}

#if canImport(os)

import os

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
extension os.Logger: LoggerProtocol {
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
        
    }
    
    public func debug(_ message: String, metadata: [String : Any]?) {
        self.error("\(message, privacy: .auto)")
    }
    
    public func notice(_ message: String, metadata _: [String: Any]?) {
        self.info("\(message, privacy: .auto)")
    }
    
    public func error(_ error: Error, metadata: [String: Any]?) {
        self.error("\(String(describing: error), privacy: .auto)")
    }
}

#endif

