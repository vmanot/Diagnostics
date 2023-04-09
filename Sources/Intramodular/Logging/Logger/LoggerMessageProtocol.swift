//
// Copyright (c) Vatsal Manot
//

#if canImport(Logging)
import Logging
#endif
#if canImport(os)
import os.log
#endif
#if canImport(OSLog)
import OSLog
#endif
import Swallow
import Swift

/// A type that represents a log message.
public protocol LogMessageProtocol: ExpressibleByStringLiteral, ExpressibleByStringInterpolation where StringLiteralType == String {
    
}

// MARK: - Conforming Implementations

#if canImport(Logging)
extension SwiftLogLogger.Message: LogMessageProtocol {
    
}
#endif

#if canImport(os)
@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
extension OSLogMessage: LogMessageProtocol {
    
}
#endif
