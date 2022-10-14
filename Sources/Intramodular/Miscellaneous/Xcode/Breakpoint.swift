//
// Copyright (c) Vatsal Manot
//

import Combine
import Swift
import os

public final class Breakpoint {
    public static func trigger() {
        enum _GenericBreakpointError: Error {
            case some
        }
        
        _ = Fail<Void, _GenericBreakpointError>(error: _GenericBreakpointError.some)
            .breakpointOnError()
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }
}
