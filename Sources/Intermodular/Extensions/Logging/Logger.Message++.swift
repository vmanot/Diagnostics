//
// Copyright (c) Vatsal Manot
//

#if canImport(Logging)

import Logging
import Swift

extension Logging.Logger.Message {
    public init(_ string: String) {
        self.init(stringLiteral: string)
    }
}

#endif
