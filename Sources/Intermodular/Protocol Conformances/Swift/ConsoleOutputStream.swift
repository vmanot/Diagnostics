//
// Copyright (c) Vatsal Manot
//

import Swift

public struct ConsoleOutputStream: TextOutputStream {
    public init() {
        
    }
    
    public func write(_ output: String) {
        print(output)
    }
}
