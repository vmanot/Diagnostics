//
// Copyright (c) Vatsal Manot
//

import Logging
import Swift

public protocol LoggerProtocol {
    associatedtype Message: LoggerMessageProtocol
    
    func debug(_ message: String, metadata: [String: Any]?)
    func notice(_ message: String, metadata: [String: Any]?)
    func error(_ error: Error, metadata: [String: Any]?)
}

public protocol LoggerMessageProtocol: ExpressibleByStringInterpolation {
    
}

// MARK: - Extensions -

extension LoggerProtocol {
    public func notice(_ message: String) {
        self.notice(message, metadata: nil)
    }
    
    public func debug(_ message: String) {
        self.debug(message, metadata: nil)
    }
    
    public func error(_ error: Error) {
        self.error(error, metadata: nil)
    }
}

// MARK: - Conformances -

extension Logging.Logger: LoggerProtocol {
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

extension Logging.Logger.Message: LoggerMessageProtocol {
    
}

#if canImport(OSLog)

import os

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
extension os.Logger {
    public typealias Message = OSLogMessage
    
    public func notice(_ message: String, metadata _: [String: Any]?) {
        self.info("\(message, privacy: .auto)")
    }

    public func error(_ error: Error, metadata: [String: Any]?) {
        self.error("\(String(describing: error), privacy: .auto)")
    }
}

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
extension os.OSLogMessage: LoggerMessageProtocol {
    
}

#endif

