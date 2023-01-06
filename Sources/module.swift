//
// Copyright (c) Vatsal Manot
//

#if canImport(Logging)
@_exported import Logging
#endif
#if canImport(os)
@_exported import os
#endif

var _isDebugBuild: Bool {
    #if DEBUG
    return true
    #else
    return false
    #endif
}
