import Foundation

@propertyWrapper
public struct CodableKey: Codable, Hashable {
    public var wrappedValue = UUID()
    
    public init() {
        
    }
    
    public init(from decoder: Decoder) throws {
        self.wrappedValue = UUID()
    }
    
    public func encode(to encoder: Encoder) throws {
        // Do nothing
    }
}

extension KeyedDecodingContainer {
    public func decode(
        _ type: CodableKey.Type,
        forKey key: Self.Key) throws -> CodableKey
    {
        return CodableKey()
    }
}

extension KeyedEncodingContainer {
    public mutating func encode(
        _ value: CodableKey,
        forKey key: KeyedEncodingContainer.Key) throws
    {
        // Do nothing
    }
}

