import ArenKit
import ArenProtocol
import Foundation

// Prefer the ArenKit wrapper to keep gateway request payloads consistent.
typealias AnyCodable = ArenKit.AnyCodable
typealias InstanceIdentity = ArenKit.InstanceIdentity

extension AnyCodable {
    var stringValue: String? { self.value as? String }
    var boolValue: Bool? { self.value as? Bool }
    var intValue: Int? { self.value as? Int }
    var doubleValue: Double? { self.value as? Double }
    var dictionaryValue: [String: AnyCodable]? { self.value as? [String: AnyCodable] }
    var arrayValue: [AnyCodable]? { self.value as? [AnyCodable] }

    var foundationValue: Any {
        switch self.value {
        case let dict as [String: AnyCodable]:
            dict.mapValues { $0.foundationValue }
        case let array as [AnyCodable]:
            array.map(\.foundationValue)
        default:
            self.value
        }
    }
}

extension ArenProtocol.AnyCodable {
    var stringValue: String? { self.value as? String }
    var boolValue: Bool? { self.value as? Bool }
    var intValue: Int? { self.value as? Int }
    var doubleValue: Double? { self.value as? Double }
    var dictionaryValue: [String: ArenProtocol.AnyCodable]? { self.value as? [String: ArenProtocol.AnyCodable] }
    var arrayValue: [ArenProtocol.AnyCodable]? { self.value as? [ArenProtocol.AnyCodable] }

    var foundationValue: Any {
        switch self.value {
        case let dict as [String: ArenProtocol.AnyCodable]:
            dict.mapValues { $0.foundationValue }
        case let array as [ArenProtocol.AnyCodable]:
            array.map(\.foundationValue)
        default:
            self.value
        }
    }
}
