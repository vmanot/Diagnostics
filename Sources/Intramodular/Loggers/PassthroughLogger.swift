//
// Copyright (c) Vatsal Manot
//

import Combine
import Swallow

/// A logger that broadcasts its entries.
public final class PassthroughLogger: @unchecked Sendable, Initiable, LoggerProtocol, ObservableObject {
    public typealias LogLevel = ClientLogLevel
    public typealias LogMessage = Message
    
    public struct Message: Equatable, CustomStringConvertible, LogMessageProtocol {
        public typealias StringLiteralType = String
        
        private var value: String
        
        public init(stringLiteral value: String) {
            self.value = value
        }
        
        public var description: String {
            return self.value
        }
    }
    
    public struct LogEntry: Hashable {
        public let sourceCodeLocation: SourceCodeLocation?
        public let message: String
    }
    
    private let lock = OSUnfairLock()
    
    public internal(set) var entries: [LogEntry] = []
    
    public init() {
        
    }
    
    public func log(
        level: LogLevel,
        _ message: @autoclosure () -> LogMessage,
        metadata: @autoclosure () -> [String : Any]?,
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
        }
    }
    
    public func log(
        level: LogLevel,
        _ message: @autoclosure () -> String,
        metadata: @autoclosure () -> [String : Any]?,
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
                    message: message()
                )
            )
        }
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
