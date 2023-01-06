//
// Copyright (c) Vatsal Manot
//

import Foundation
import os.log
#if DEBUG
import _SwiftOSOverlayShims
#endif

public struct XcodeRuntimeIssueLogger {
    /// Returns the shared default runtime issue logger with a generic category.
    public static let `default` = Self(category: "Runtime issues")
    
    private static let commonSubsystem = "com.apple.runtime-issues"
    
    @usableFromInline
    let log: OSLog
    @usableFromInline
    let callsiteCache = CallsiteCache()
    
    public var isEnabled = _isDebugBuild
    
    /// Initializes a custom runtime issue logger with a custom category.
    public init(category: StaticString) {
        self.log = OSLog(subsystem: Self.commonSubsystem, category: String(_staticString: category))
    }
    
    /// Log a runtime issue to the console.
    ///
    /// When executed while attached to Xcode's debugger, this will have the additional effect
    /// of highlighting the issue and providing heads-up information regarding the issue.
    @_transparent
    public func raise(
        _ warningFormat: StaticString,
        file: StaticString = #file,
        line: UInt = #line,
        vaList: CVarArg...
    ) {
        guard isEnabled else {
            return
        }
        
        guard log.isEnabled(type: .fault), callsiteCache.shouldRaiseIssue(in: file, on: line) else {
            return
        }
        
        guard let handle = XcodeRuntimeIssueLogger.systemFrameworkHandle else {
            return RTI_RUNTIME_ISSUES_UNAVAILABLE()
        }
        
        os_log(.fault, dso: handle, log: log, warningFormat, vaList)
    }
}

// MARK: - Supplementary API -

@_transparent
public func runtimeIssue(
    _ warningFormat: StaticString,
    file: StaticString = #file,
    line: UInt = #line,
    _ arguments: CVarArg...
) {
    XcodeRuntimeIssueLogger.default.raise(
        warningFormat,
        file: file,
        line: line,
        vaList: arguments
    )
}

// MARK: - Auxiliary -

extension XcodeRuntimeIssueLogger {
    public static let systemFrameworkHandle: UnsafeRawPointer? = {
        for i in 0..<_dyld_image_count() {
            // Technically any system framework would work, but this was inspired by SwiftUI's use
            // of runtime issues to report non-fatal but unexpected behavior.
            guard let name = _dyld_get_image_name(i).flatMap(String.init(utf8String:)), name.contains("SwiftUI") else { continue }
            return UnsafeRawPointer(_dyld_get_image_header(i))
        }
        return nil
    }()
    
    public class CallsiteCache {
        private struct Invocation: Hashable {
            var file: HashedStaticString
            var line: UInt
        }
        
        private var invocations = Set<Invocation>()
        
        /// Returns whether to raise a runtime issue in a file on a particular line.
        ///
        /// A notification of a runtime issue will only arise once, so only the first call will return true.
        public func shouldRaiseIssue(in file: StaticString, on line: UInt) -> Bool {
            print(invocations)
            return invocations.insert(Invocation(file: HashedStaticString(file), line: line)).inserted
        }
    }
}

private var hasLoggedUnavailable = false

public func RTI_RUNTIME_ISSUES_UNAVAILABLE() {
    if hasLoggedUnavailable {
        return
    }
    
    os_log(.fault, "Warn only once: a runtime issue logging expectation was violated. Runtime issues will not be logged. Set a symbolic breakpoint on 'RTI_RUNTIME_ISSUES_UNAVAILABLE' to trace.")
    
    hasLoggedUnavailable = true
}

struct HashedStaticString: Hashable {
    private let base: StaticString
    
    init(_ base: StaticString) {
        self.base = base
    }
    
    func hash(into hasher: inout Hasher) {
        base.withUTF8Buffer { buffer in
            hasher.combine(bytes: UnsafeRawBufferPointer(buffer))
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.base.withUTF8Buffer { lhs in
            rhs.base.withUTF8Buffer { rhs in
                zip(lhs, rhs).first(where: { $0.0 != $0.1 }) == nil
            }
        }
    }
}
