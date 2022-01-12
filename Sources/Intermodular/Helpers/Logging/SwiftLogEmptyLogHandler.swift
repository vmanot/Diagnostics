//
// Copyright (c) Vatsal Manot
//

import Logging
import Swift

public class SwiftLogEmptyLogHandler: Logging.LogHandler {
    public var metadata: [String: Logging.Logger.Metadata.Value] = [:]
    public var logLevel: Logging.Logger.Level = .debug
    
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
        
    }
    
    public func log(
        level: Logging.Logger.Level,
        message: Logging.Logger.Message,
        metadata: Logging.Logger.Metadata?,
        file: String,
        function: String,
        line: UInt
    ) {
        
    }
}
