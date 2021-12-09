//
// Copyright (c) Vatsal Manot
//

import Logging
import Swift

extension Logging.Logger.Level {
    public var name: String {
        switch self {
            case .trace:
                return "Trace"
            case .debug:
                return "Debug"
            case .info:
                return "Info"
            case .notice:
                return "Notice"
            case .warning:
                return "Warning"
            case .error:
                return "Error"
            case .critical:
                return "Critical"
        }
    }
}
