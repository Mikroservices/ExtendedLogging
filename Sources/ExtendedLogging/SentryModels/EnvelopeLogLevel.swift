import Foundation
import Logging

internal enum EnvelopeLogLevel: String, Encodable {
    case fatal
    case error
    case warning
    case info
    case debug
    
    init(level: Logger.Level) {
        switch level {
        case .trace:
            self = .debug
        case .debug:
            self = .debug
        case .info:
            self = .info
        case .notice:
            self = .info
        case .warning:
            self = .warning
        case .error:
            self = .error
        case .critical:
            self = .fatal
        }
    }
}
