import Foundation

internal struct EnvelopeErrorValues: Encodable {
    let values: [EnvelopeErrorValue]
}

internal struct EnvelopeErrorValue: Encodable {
    let type: String
    let value: String
    let stackTrace: EnvelopeFrames
    
    enum CodingKeys: String, CodingKey {
        case type
        case value
        case stackTrace = "stacktrace"
    }
}
