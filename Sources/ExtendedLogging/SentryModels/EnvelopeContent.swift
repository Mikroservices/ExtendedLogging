import Foundation
import Logging

internal struct EnvelopeContent: Encodable {
    let level: EnvelopeLogLevel
    let eventId: String
    let logger: String
    let platform: String
    let serverName: String
    let timestamp: Double
    let environment: String
    let contexts: EnvelopeContext
    let message: String?
    let exception: EnvelopeErrorValues?
    
    enum CodingKeys: String, CodingKey {
        case level
        case eventId = "event_id"
        case logger
        case platform
        case serverName = "server_name"
        case timestamp
        case environment
        case contexts
        case message
        case exception
    }
}
