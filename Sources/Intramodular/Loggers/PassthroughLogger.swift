//
// Copyright (c) Vatsal Manot
//

import Combine
import Logging
import Swallow

/// A logger that broadcasts its entries.
public final class PassthroughLogger: @unchecked Sendable, Initiable, LoggerProtocol, ObservableObject {
    public struct LogEntry: Hashable {
        public let sourceCodeLocation: SourceCodeLocation?
        public let message: String
    }
    
    public typealias LogLevel = ClientLogLevel
    public typealias LogMessage = Logging.Logger.Message
    
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
