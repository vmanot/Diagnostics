//
// Copyright (c) Vatsal Manot
//

import Logging
import Swift

public protocol LoggerMetadataConvertible {
    var loggerMetadata: Logging.Logger.Metadata { get }
}
