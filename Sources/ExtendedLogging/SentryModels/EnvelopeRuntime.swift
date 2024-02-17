import Foundation

internal struct EnvelopeRuntime: Encodable {
    let name: String
    
    init() {
        self.name = "Swift"
    }
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}
