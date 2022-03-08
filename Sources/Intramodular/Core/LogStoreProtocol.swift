//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swift

/// A type that represents a log store.
///
/// A log store allows you to fetch and query log messages.
public protocol LogStoreProtocol {
    associatedtype LogEntry
    associatedtype LogEntries: Sequence where LogEntries.Element == LogEntry
    associatedtype LogEnumeratorOptions
    associatedtype LogPosition

    func getEntries(
        with options: LogEnumeratorOptions,
        at position: LogPosition?,
        matching predicate: NSPredicate?
    ) throws -> LogEntries
}
