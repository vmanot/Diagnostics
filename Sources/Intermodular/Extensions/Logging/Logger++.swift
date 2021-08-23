//
// Copyright (c) Vatsal Manot
//

import Logging
import Swallow

extension Logger {
    public func log(
        _ error: Error,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        log(
            level: .error,
            Logger.Message(String(describing: error)),
            metadata: metadata(),
            file: file,
            function: function,
            line: line
        )
    }
}
