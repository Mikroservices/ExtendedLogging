import Foundation
import Logging

public struct SentryLogger: LogHandler {
    
    public var metadata = Logger.Metadata() {
        didSet {
            self.logFormatter.metadata = self.metadata
        }
    }

    public var logLevel: Logger.Level = .info
    private let sentryWriter: SentryWriter
    private var logFormatter: LogFormatter
    
    public init(label: String,
                dsn: String?,
                application: String? = nil,
                version: String? = nil,
                level: Logger.Level = .debug,
                metadata: Logger.Metadata = [:]) {
        self.label = label
        self.logLevel = level
        self.metadata = metadata
        self.logFormatter = SentryFormatter(application: application, version: version)
        self.sentryWriter = SentryWriter(dsn: dsn)
    }

    public let label: String
    
    public func log(level: Logger.Level,
                    message: Logger.Message,
                    metadata: Logger.Metadata?,
                    file: String,
                    function: String,
                    line: UInt) {

        let message = try? self.logFormatter.format(label: self.label,
                                                    level: level,
                                                    message: message,
                                                    metadata: metadata,
                                                    file: file,
                                                    function: function,
                                                    line: line)

        self.sentryWriter.write(message: message)
    }
    
    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return self.metadata[metadataKey]
        }
        set {
            self.metadata[metadataKey] = newValue
        }
    }
}
