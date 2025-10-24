import SwiftUI

// MARK: - Codable AppStorage Wrapper
@propertyWrapper
struct CodableAppStorage<Value: Codable>: DynamicProperty {
    @AppStorage private var data: Data
    private let defaultValue: Value
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) {
        self.defaultValue = wrappedValue
        // ✅ FIX: Provide a default Data value for the AppStorage property
        _data = AppStorage(wrappedValue: Data(), key, store: store)
    }

    var wrappedValue: Value {
        get {
            guard !data.isEmpty,
                  let decoded = try? decoder.decode(Value.self, from: data)
            else {
                return defaultValue
            }
            return decoded
        }
        nonmutating set {
            if let encoded = try? encoder.encode(newValue) {
                data = encoded
            }
        }
    }
}
