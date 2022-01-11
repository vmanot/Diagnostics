//
// Copyright (c) Vatsal Manot
//

import Combine
import Logging

public class TextDump: ObservableObject, TextOutputStream {
    public internal(set) var lines: [String] = []
    
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
