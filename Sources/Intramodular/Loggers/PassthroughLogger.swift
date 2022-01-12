//
// Copyright (c) Vatsal Manot
//

import Combine
import Logging
import Swallow

public final class PassthroughLogger: Initiable, LoggerProtocol, ObservableObject {
    public typealias LogLevel = ClientLogLevel
    public typealias LogMessage = Logging.Logger.Message
    
    public struct Entry: Hashable {
        public let sourceCodeLocation: SourceCodeLocation?
        public let message: String
    }
    
    public internal(set) var entries: [Entry] = []
    
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
