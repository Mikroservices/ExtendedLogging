import Foundation

internal struct EnvelopeApplication: Encodable {
    let name: String
    
    init() {
        self.name = ProcessInfo.processInfo.processName
    }
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}
