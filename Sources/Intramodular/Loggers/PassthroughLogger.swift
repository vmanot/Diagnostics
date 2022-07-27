//
// Copyright (c) Vatsal Manot
//

import Combine
import Swallow

/// A logger that broadcasts its entries.
public final class PassthroughLogger: @unchecked Sendable, LoggerProtocol, ObservableObject {
    public typealias LogLevel = ClientLogLevel
    public typealias LogMessage = Message
    
    public struct Message: Equatable, CustomStringConvertible, LogMessageProtocol {
        public typealias StringLiteralType = String
        
        private var rawValue: String
        
        public var description: String {
            rawValue
        }

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(stringLiteral value: String) {
            self.rawValue = value
        }
    }
    
    public struct LogEntry: Hashable {
        public let sourceCodeLocation: SourceCodeLocation?
        public let message: String
    }
    
    public struct Source: CustomStringConvertible {
        public enum Storage {
            case something(Any)
            case object(Weak<AnyObject>)
        }
        
        private let storage: Storage
        
        public var description: String {
            switch storage {
                case .something(let value):
                    return String(describing: value)
                case .object(let object):
                    if let object = object.value {
                        return String(describing: object)
                    } else {
                        return "(null)"
                    }
            }
        }
        
        public init(_ value: Any) {
            if isClass(type(of: value)) {
                self.storage = .object(Weak(value as AnyObject))
            } else {
                self.storage = .something(value)
            }
        }
        
        public init(_ object: AnyObject) {
            self.storage = .object(Weak(object))
        }
    }
    
    private let lock = OSUnfairLock()
    
    public let source: Source
    
    public internal(set) var entries: [LogEntry] = []
    
    public init(source: Source) {
        self.source = source
    }
    
    public func log(
        level: LogLevel,
        _ message: @autoclosure () -> LogMessage,
        metadata: @autoclosure () -> [String: Any]?,
        file: String,
        function: String,
        line: UInt
    ) {
        lock.withCriticalScope {
            entries.append(
                LogEntry(
                    sourceCodeLocation: SourceCodeLocation(
                        file: file,
                        function: function,
                        line: line,
                        column: nil
                    ),
                    message: message().description
                )
            )
            
            if PassthroughLoggerGlobalConfiguration.outputToConsole {
                print("[\(source.description)] \(message())")
            }
        }
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
            LogMessage(rawValue: message()),
            metadata: metadata(),
            file: file,
            function: function,
            line: line
        )
    }
}

// MARK: - Protocol Conformances -

extension PassthroughLogger: TextOutputStream {
    public func write(_ string: String) {
        entries.append(.init(sourceCodeLocation: nil, message: string))
        
        Task {
            await MainActor.run {
                self.objectWillChange.send()
            }
        }
    }
}

// MARK: - Auxiliary Implementation -

enum PassthroughLoggerGlobalConfiguration {
    @TaskLocal
    static var outputToConsole: Bool = false
}


extension PassthroughLogger {
    public static func outputToConsole(
        _ body: () throws -> Void
    ) rethrows {
        try PassthroughLoggerGlobalConfiguration.$outputToConsole.withValue(true) {
            try body()
        }
    }
    
    public static func outputToConsole(
        _ body: () async throws -> Void
    ) async rethrows {
        try await PassthroughLoggerGlobalConfiguration.$outputToConsole.withValue(true) {
            try await body()
        }
    }
}
