//
// Copyright (c) Vatsal Manot
//

#if canImport(Logging)

import Foundation
import Logging
import Swift

/// A SwiftLog logging backend suitable for streaming output to a given text output stream.
public final class SwiftLogConsoleLogHandler: LogHandler {
    private let lock = OSUnfairLock()
    
    public let label: String
    public var metadata: Logging.Logger.Metadata
    public var logLevel: Logging.Logger.Level
    
    public private(set) var output: TextOutputStream
    
    public init(
        label: String,
        output: TextOutputStream = ConsoleOutputStream(),
        level: Logging.Logger.Level = .debug,
        metadata: Logging.Logger.Metadata = [:]
    ) {
        self.label = label
        self.output = output
        self.metadata = metadata
        self.logLevel = level
    }
    
    public subscript(metadataKey key: String) -> Logging.Logger.Metadata.Value? {
        get {
            return metadata[key]
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
        var text: String = ""
        
        if logLevel <= .trace {
            text += "[\(label)] "
        }
        
        text += "[\(level.name)] \(message.description)"
        
        let allMetadata = (metadata ?? [:]).merging(self.metadata, uniquingKeysWith: { (lhs, _) in lhs })
        
        if !allMetadata.isEmpty {
            text += " " + allMetadata.sortedDescriptionWithoutQuotes
        }
        
        // Log file info if log level is `.debug` or lower.
        if logLevel <= .debug {
            let fileInfo = getConciseSourcePath(fromPath: file) + ":" + line.description
            
            text += " (" + fileInfo + ")"
        }
        
        lock.withCriticalScope {
            output.write(text)
        }
    }
    
    private func getConciseSourcePath(fromPath path: String) -> String {
        let separator: Substring = path.contains("Sources") ? "Sources" : "Tests"
        
        return path.split(separator: "/")
            .split(separator: separator)
            .last?
            .joined(separator: "/") ?? path
    }
}

// MARK: - Auxiliary Implementation -

extension Logging.Logger.Metadata {
    fileprivate var sortedDescriptionWithoutQuotes: String {
        let contents = Array(self)
            .sorted(by: { $0.0 < $1.0 })
            .map { "\($0.description): \($1)" }
            .joined(separator: ", ")
        
        return "[\(contents)]"
    }
}

#endif
