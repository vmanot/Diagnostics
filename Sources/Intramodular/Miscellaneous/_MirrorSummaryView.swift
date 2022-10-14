//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct _MirrorSummaryView: View {
    public let mirror: Mirror
    
    public init(mirror: Mirror) {
        self.mirror = mirror
    }
    
    public var body: some View {
        Form {
            Content(mirror: mirror)
        }
    }
    
    struct Content: View {
        let mirror: Mirror
        
        var body: some View {
            ForEach(Array(mirror.children.enumerated()), id: \.offset) { (offset, labelAndValue) in
                let label = labelAndValue.label ?? offset.description
                let value = labelAndValue.value
                
                if Mirror(reflecting: labelAndValue.value).children.count <= 1 {
                    #if !os(macOS) && !targetEnvironment(macCatalyst)
                    LabeledContent(label) {
                        Text(String(describing: value))
                    }
                    #endif
                } else {
                    NavigationLink(label) {
                        _MirrorSummaryView(mirror: Mirror(reflecting: value))
                    }
                }
            }
        }
    }
}
