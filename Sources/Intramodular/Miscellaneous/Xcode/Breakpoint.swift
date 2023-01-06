//
// Copyright (c) Vatsal Manot
//

import Combine
import Swift
import os

public struct Breakpoint {
    @_transparent
    public static func trigger() {
        #if DEUB
        raise(SIGTRAP)
        #endif
    }

    static func _altTrigger() {
        _ = Fail<Void, _GenericBreakpointError>(error: _GenericBreakpointError.some)
            .breakpointOnError()
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }
    
    enum _GenericBreakpointError: Error {
        case some
    }
}
