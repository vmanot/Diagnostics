//
// Copyright (c) Vatsal Manot
//

import Combine
import Logging
import Swallow

/// A type that can be the target of error-logging operations.
public protocol ErrorLogger {
    func log(_ error: Error)
}

// MARK: - API -

extension Publisher {
    /// Logs failures to a given error logger.
    public func logFailure(to logger: ErrorLogger) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                logger.log(error)
            }
        })
    }
}
