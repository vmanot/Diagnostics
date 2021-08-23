//
// Copyright (c) Vatsal Manot
//

import Logging
import Swift

extension Logger.MetadataValue {
    public init<T>(from value: T) {
        if let value = value as? CustomStringConvertible {
            self = .stringConvertible(value)
        } else {
            self = .string(String(describing: value))
        }
    }
}
