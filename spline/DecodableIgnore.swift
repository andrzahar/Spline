import SwiftUI

@propertyWrapper
public struct DecodableIgnored<T: Hashable>: Decodable, Hashable {
    public var wrappedValue: T?
    
    public init(wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }
    
    public init(from decoder: Decoder) throws {
        self.wrappedValue = nil
    }
}

extension KeyedDecodingContainer {
    public func decode<T>(
        _ type: DecodableIgnored<T>.Type,
        forKey key: Self.Key) throws -> DecodableIgnored<T>
    {
        return DecodableIgnored(wrappedValue: nil)
    }
}
