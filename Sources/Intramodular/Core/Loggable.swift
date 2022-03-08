//
// Copyright (c) Vatsal Manot
//

import Swift

/// A type capable of being recorded in a log.
public protocol Loggable {
    var logger: PassthroughLogger { get }
}
