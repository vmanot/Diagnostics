//
// Copyright (c) Vatsal Manot
//

import Swift

public protocol ConsoleOutputStream: TextOutputStream {
    func write(_ output: String)
}

// MARK: - Implementations -

public struct DefaultConsoleStream: ConsoleOutputStream {
    public init() {
        
    }
    
    public func write(_ output: String) {
        print(output)
    }
}

extension ConsoleOutputStream where Self == DefaultConsoleStream {
    public static var `default`: DefaultConsoleStream {
        .init()
    }
}
