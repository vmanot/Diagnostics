//
// Copyright (c) Vatsal Manot
//

import Logging
import Swift

extension Logging.Logger.Message {
    public init(_ string: String) {
        self.init(stringLiteral: string)
    }
}
