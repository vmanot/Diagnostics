//
// Copyright (c) Vatsal Manot
//

import Swift

/// A type capable of being recorded in a log.
public protocol Loggable {
    var logger: PassthroughLogger { get }
}

// MARK: - Implementation -

private var logger_objcAssociationKey: UInt = 0

extension Loggable {
    public var logger: PassthroughLogger {
        PassthroughLogger(source: PassthroughLogger.Source(self))
    }
}

extension Loggable where Self: AnyObject {
    public var logger: PassthroughLogger {
        if let result = objc_getAssociatedObject(self, &logger_objcAssociationKey) as? PassthroughLogger {
            return result
        } else {
            objc_sync_enter(self)
            
            defer {
                objc_sync_exit(self)
            }

            let result = PassthroughLogger(source: PassthroughLogger.Source(self))
            
            objc_setAssociatedObject(self, &logger_objcAssociationKey, result, .OBJC_ASSOCIATION_RETAIN)
            
            return result
        }
    }
}
