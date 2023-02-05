//
// Copyright (c) Vatsal Manot
//

import Swift

public protocol StructuredLogger<Value> {
    associatedtype Value
}

public protocol LogScope {
    
}

public protocol ScopedLogger<Scope>: LoggerProtocol {
    associatedtype Scope: LogScope
    
    typealias Foo<T: LogScope> = ScopedLogger<T> & StructuredLogger
    
    func scoped<T: LogScope>(to scope: T) throws -> any Foo<T>
}

open class _StaticMembersOf<T> {
    public required init() {
        
    }
}

@dynamicMemberLookup
public protocol _HasStaticMembers {
    associatedtype _StaticMembers: _StaticMembersOf<Self>
    
    static subscript<T>(dynamicMember keyPath: KeyPath<_StaticMembers, T>) -> T { get }
}

extension _HasStaticMembers {
    static subscript<T>(dynamicMember keyPath: KeyPath<_StaticMembers, T>) -> T {
        get {
            staticMemberOf(Self.self, keyPath: keyPath)
        }
    }
}

enum FooScope {
    
}

extension FooScope: _HasStaticMembers {
    public final class _StaticMembers: _StaticMembersOf<FooScope> {
        public let bar: Int = 69
    }
}

func staticMemberOf<T, U>(
    _ type: T.Type,
    keyPath: KeyPath<T._StaticMembers, U>
) -> U where T: _HasStaticMembers {
    type._StaticMembers.init()[keyPath: keyPath]
}

let bar: KeyPath<FooScope.Type, FooScope.Type> = \(FooScope.Type).self
