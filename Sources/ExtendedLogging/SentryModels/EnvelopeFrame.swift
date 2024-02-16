import Foundation

internal struct EnvelopeFrames: Encodable {
    let frames: [EnvelopeFrame]
}

internal struct EnvelopeFrame: Encodable {
    let fileName: String
    let function: String
    let lineNumber: UInt
    
    enum CodingKeys: String, CodingKey {
        case fileName = "filename"
        case function
        case lineNumber = "lineno"
    }
}
