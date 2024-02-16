import Foundation
import Logging

internal struct EnvelopeContent: Encodable {
    let level: Logger.Level
    let eventId: String
    let platform: String
    let timestamp: Double
    let environment: String
    let message: String?
    let exception: EnvelopeErrorValues?
    
    enum CodingKeys: String, CodingKey {
        case level
        case eventId = "event_id"
        case platform
        case timestamp
        case environment
        case message
        case exception
    }
}
