//
//  Extensions.swift
//  GermanTests
//
//  Created by Serge Sinkevych on 6/22/25.
//

import Foundation

extension Dictionary {
    subscript(safe key: Key) -> String {
        guard let value = self[key] as? String else {
            print("⚠️ Missing key: \(key)")
            return ""
        }
        return value
    }
}
