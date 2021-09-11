//
// Copyright (c) Vatsal Manot
//

import Logging
import os
import Swift

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
public class SystemLogHandler: Logging.LogHandler {
    public var metadata: [String: Logging.Logger.Metadata.Value] = [:]
    public var logLevel: Logging.Logger.Level = .debug
    
    private let logger: os.Logger
    
    public init(label: String) {
        let labelComponents = label.components(separatedBy: ".")
        
        let subsystem = labelComponents.prefix(3).joined(separator: ".")
        let category = labelComponents.dropFirst(3).joined(separator: ".")
        
        self.logger = .init(subsystem: subsystem, category: category)
    }
    
    public subscript(metadataKey key: String) -> Logging.Logger.Metadata.Value? {
        get {
            metadata[key]
        } set {
            metadata[key] = newValue
        }
    }
    
    public func log(
        level: Logging.Logger.Level,
        message: Logging.Logger.Message,
        metadata: Logging.Logger.Metadata?,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) {
        logger.log(level: .init(level), "\(message.description, privacy: .sensitive)")
    }
    
    public func log(
        level: Logging.Logger.Level,
        message: Logging.Logger.Message,
        metadata: Logging.Logger.Metadata?,
        file: String,
        function: String,
        line: UInt
    ) {
        logger.log(level: .init(level), "\(message.description)")
    }
}

// MARK: - Auxiliary Implementation -

extension OSLogType {
    fileprivate init(_ level: Logging.Logger.Level) {
        switch level {
            case .trace:
                self = .debug
            case .debug:
                self = .debug
            case .info:
                self = .info
            case .notice:
                self = .info
            case .warning:
                self = .error
            case .error:
                self = .error
            case .critical:
                self = .fault
        }
    }
}
