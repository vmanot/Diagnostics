//
// Copyright (c) Vatsal Manot
//

import Combine
import Logging

public class TextDump: ObservableObject, TextOutputStream {
    public private(set) var lines: [String] = []
    
    public init() {
        
    }
    
    public func write(_ string: String) {
        lines.append(string)
        
        Task.detached(priority: .userInitiated) {
            await MainActor.run {
                self.objectWillChange.send()
            }
        }
    }
}

// TODO: Improve implementation
extension TextDump: LoggerProtocol {
    public func debug(_ message: String, metadata: [String: Any]?) {
        lines.append("[DEBUG] \(message)")
    }
    
    public func notice(_ message: String, metadata: [String: Any]?) {
        lines.append("[NOTICE] \(message)")
    }
    
    public func error(_ error: Error, metadata: [String: Any]?) {
        lines.append("[ERROR] \(error)")
    }
}
