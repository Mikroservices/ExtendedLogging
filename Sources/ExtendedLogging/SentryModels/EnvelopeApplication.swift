import Foundation

internal struct EnvelopeApplication: Encodable {
    let name: String
    
    init() {
        self.name = ProcessInfo().processName
    }
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}
