//
// Copyright (c) Vatsal Manot
//

import Foundation
import Logging
import Swift

/// A SwiftLog log handler suitable for outputting to a console.
public struct SwiftLogConsoleLogHandler: LogHandler {
    public let label: String
    public var metadata: Logging.Logger.Metadata
    public var logLevel: Logging.Logger.Level
    public let console: ConsoleOutputStream
    
    public init(
        label: String,
        console: ConsoleOutputStream = .default,
        level: Logging.Logger.Level = .debug,
        metadata: Logging.Logger.Metadata = [:]
    ) {
        self.label = label
        self.metadata = metadata
        self.logLevel = level
        self.console = console
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
        
        if self.logLevel <= .trace {
            text += "[\(self.label)] "
        }
        
        text += "[\(level.name)]"
        + " "
        + message.description
        
        let allMetadata = (metadata ?? [:]).merging(self.metadata) { (a, _) in a }
        
        if !allMetadata.isEmpty {
            // only log metadata if not empty
            text += " " + allMetadata.sortedDescriptionWithoutQuotes
        }
        
        // log file info if we are debug or lower
        if self.logLevel <= .debug {
            // log the concise path + line
            let fileInfo = self.conciseSourcePath(file) + ":" + line.description
            text += " (" + fileInfo + ")"
        }
        
        self.console.write(text)
    }
    
    /// splits a path on the /Sources/ folder, returning everything after
    ///
    ///     "/Users/developer/dev/MyApp/Sources/Run/main.swift"
    ///     // becomes
    ///     "Run/main.swift"
    ///
    private func conciseSourcePath(_ path: String) -> String {
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
