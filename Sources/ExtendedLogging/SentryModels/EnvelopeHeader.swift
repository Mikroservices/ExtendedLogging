import Foundation

internal struct EnvelopeHeader: Encodable {
    let eventId: String
    let sentAt: Date
    let sdk: EnvelopeSdk
    
    enum CodingKeys: String, CodingKey {
        case eventId = "event_id"
        case sentAt = "sent_at"
        case sdk
    }
}
