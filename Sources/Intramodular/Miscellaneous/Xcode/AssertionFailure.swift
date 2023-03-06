//
// Copyright (c) Vatsal Manot
//

import Combine
import Swift
import os

/// A Swift `Error` that represents an assertion failure.
public struct AssertionFailure: Error {
    @_transparent
    public init() {
        XcodeRuntimeIssueLogger.default.raise("Assertion failure raised.")
    }
}
