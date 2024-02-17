import Foundation
import Logging

public class SentryFormatter: LogFormatter {
    public var metadata = Logger.Metadata()
    
    private let application: String?
    private let version: String?
    private var prettyMetadata: Dictionary<String, String> = [:]
    private let jsonEncoder: JSONEncoder
    private let newLine = "\n".data(using: .utf8)!
    
    public init(application: String? = nil, version: String? = nil) {
        self.application = application
        self.version = version

        self.jsonEncoder = JSONEncoder()
        self.jsonEncoder.dateEncodingStrategy = JSONEncoder.DateEncodingStrategy.iso8601
    }
    
    public func format(label: String,
                       level: Logger.Level,
                       message: Logger.Message,
                       metadata logMetadata: Logger.Metadata?,
                       file: String,
                       function: String,
                       line: UInt) throws -> Data? {
        let eventId = UUID().uuidString
        let currentDate = Date()

        let header = EnvelopeHeader(eventId: eventId,
                                    sentAt: currentDate,
                                    sdk: EnvelopeSdk(name: "dev.mczachurski.mikroservices.extended-logging", version: "1.0.0"))
        
        let type = EnvelopeType()
        let content = self.getEnvelopeContent(level: level,
                                              metadata: logMetadata,
                                              message: message.description,
                                              eventId: eventId,
                                              logger: label,
                                              currentDate: currentDate,
                                              fileName: file,
                                              function: function,
                                              line: line)
        
        let headerData = try jsonEncoder.encode(header)
        let typeData = try jsonEncoder.encode(type)
        let contentData = try jsonEncoder.encode(content)
        
        let data = headerData + newLine + typeData + newLine + contentData
        return data
    }
    
    private func getEnvelopeContent(
        level: Logger.Level,
        metadata logMetadata: Logger.Metadata?,
        message: String,
        eventId: String,
        logger: String,
        currentDate: Date,
        fileName: String,
        function: String,
        line: UInt
    ) -> EnvelopeContent {
        if level == Logger.Level.critical || level == Logger.Level.error {
            let lastFileName = String(fileName.split(separator: "/").last ?? "")
            
            return EnvelopeContent(level: EnvelopeLogLevel(level: level),
                                   eventId: eventId,
                                   logger: logger,
                                   platform: "native",
                                   serverName: self.getServerName(),
                                   timestamp: currentDate.timeIntervalSince1970,
                                   environment: "production",
                                   contexts: EnvelopeContext(name: self.application, version: self.version),
                                   extra: self.getExtraData(metadata: logMetadata),
                                   message: nil,
                                   exception: EnvelopeErrorValues(values: [
                                       EnvelopeErrorValue(type: "Error",
                                                          value: message,
                                                          stackTrace: EnvelopeFrames(frames: [
                                                              EnvelopeFrame(fileName: lastFileName,
                                                                            function: function,
                                                                            lineNumber: line)
                                                          ]))
                                   ]))
        } else {
            return EnvelopeContent(level: EnvelopeLogLevel(level: level),
                                   eventId: eventId,
                                   logger: logger,
                                   platform: "native",
                                   serverName: self.getServerName(),
                                   timestamp: currentDate.timeIntervalSince1970,
                                   environment: "production",
                                   contexts: EnvelopeContext(name: self.application, version: self.version),
                                   extra: self.getExtraData(metadata: logMetadata),
                                   message: message,
                                   exception: nil)
        }
    }
    
    private func getExtraData(metadata logMetadata: Logger.Metadata?) -> Dictionary<String, String> {
        var extra: Dictionary<String, String> = [:]
        
        self.metadata.forEach({ (key: String, value: Logger.MetadataValue) in
            extra[key] = value.description
        })
        
        if let logMetadata {
            logMetadata.forEach({ (key: String, value: Logger.MetadataValue) in
                extra[key] = value.description
            })
        }
        
        return extra
    }
    
    private func getServerName() -> String {
        return Host.current().localizedName ?? ""
    }
}
