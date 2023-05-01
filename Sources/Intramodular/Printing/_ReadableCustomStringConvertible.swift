//
// Copyright (c) Vatsal Manot
//

import Swallow

public struct _ReadableCustomStringConvertible<T>: CustomDebugStringConvertible, CustomStringConvertible {
    public let base: T
    
    public var debugDescription: String {
        description
    }
    
    public var description: String {
        guard let base = Optional(_unwrapping: base) else {
            return "nil"
        }
        
        if let base = base as? CustomStringConvertible {
            return base.description
        } else {
            return Metatype(type(of: base)).name
        }
    }
    
    public init(from base: T) {
        self.base = base
    }
}
