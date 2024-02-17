import Foundation

internal struct EnvelopeApplication: Encodable {
    let name: String?
    let version: String?
    
    init(name: String?, version: String?) {
        self.name = name
        self.version = version
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "app_name"
        case version = "app_version"
    }
}
