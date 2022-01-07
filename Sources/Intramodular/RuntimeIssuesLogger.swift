//
// Copyright (c) Vatsal Manot
//

import Logging
import Swift
import os

/// A logger that emits runtime issues.
public struct RuntimeIssuesLogger {
    public static let `default` = RuntimeIssuesLogger()

    @_transparent
    @inline(__always)
    public func log(_ type: os.OSLogType, message: StaticString) {
        #if DEBUG
        os_log(
            type,
            dso: _com_apple_runtime_issues_dso_and_log.dso,
            log: _com_apple_runtime_issues_dso_and_log.log,
            message,
            []
        )
        #endif
    }
}

// MARK: - Auxiliary Implementation -

#if DEBUG
public let _com_apple_runtime_issues_dso_and_log = (
    dso: { () -> UnsafeMutableRawPointer in
        var info = Dl_info()
        dladdr(dlsym(dlopen(nil, RTLD_LAZY), "LocalizedString"), &info)
        return info.dli_fbase
    }(),
    log: OSLog(subsystem: "com.apple.runtime-issues", category: "Diagnostics")
)
#endif
