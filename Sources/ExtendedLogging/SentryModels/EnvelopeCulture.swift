import Foundation

internal struct EnvelopeCulture: Encodable {
    let locale: String
    let timezone: String
    
    init() {
        self.locale = Locale.current.identifier
        self.timezone = TimeZone.current.identifier
    }
    
    enum CodingKeys: String, CodingKey {
        case locale
        case timezone
    }
}
