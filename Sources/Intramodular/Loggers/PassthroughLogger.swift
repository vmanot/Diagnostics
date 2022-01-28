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
        entries.append(
            .init(
                sourceCodeLocation: SourceCodeLocation(
                    file: file, function: function, line: line, column: nil
                ),
                message: message().description
            )
        )
    }
    
    public func log(
        level: LogLevel,
        _ message: @autoclosure () -> String,
        metadata: @autoclosure () -> [String : Any]?,
        file: String,
        function: String,
        line: UInt
    ) {
        entries.append(
            .init(
                sourceCodeLocation: SourceCodeLocation(
                    file: file, function: function, line: line, column: nil
                ),
                message: message()
            )
        )
    }
}

extension PassthroughLogger: TextOutputStream {
    public func write(_ string: String) {
        entries.append(.init(sourceCodeLocation: nil, message: string))
        
        Task.detached(priority: .userInitiated) {
            await MainActor.run {
                self.objectWillChange.send()
            }
        }
    }
}
