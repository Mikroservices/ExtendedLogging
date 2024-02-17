import Foundation
import Logging

public class SentryFormatter: LogFormatter {
    public var metadata = Logger.Metadata() {
        didSet {
            self.prettyMetadata = self.prettify(self.metadata)
        }
    }
    
    private var prettyMetadata: String?
    private let jsonEncoder: JSONEncoder
    private let newLine = "\n".data(using: .utf8)!
    
    public init() {
        self.jsonEncoder = JSONEncoder()
        self.jsonEncoder.dateEncodingStrategy = JSONEncoder.DateEncodingStrategy.iso8601
    }
    
    public func format(label: String,
                       level: Logger.Level,
                       message: Logger.Message,
                       metadata: Logger.Metadata?,
                       file: String,
                       function: String,
                       line: UInt) throws -> Data? {

        // TODO: Save metadata as additional fields.
//        let prettyMetadata = metadata?.isEmpty ?? true
//            ? self.prettyMetadata
//            : self.prettify(self.metadata.merging(metadata!, uniquingKeysWith: { _, new in new }))
//        let messageLine = "(\(prettyMetadata.map { ", \($0)" } ?? "")): \(message)\n"
        
        let eventId = UUID().uuidString // self.createRandomString(length: 32)
        let currentDate = Date()

        let header = EnvelopeHeader(eventId: eventId,
                                    sentAt: currentDate,
                                    sdk: EnvelopeSdk(name: "dev.mczachurski.mikroservices.extended-logging", version: "1.0.0"))
        
        let type = EnvelopeType()
        let content = self.getEnvelopeContent(level: level,
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
    
    private func prettify(_ metadata: Logger.Metadata) -> String? {
        return !metadata.isEmpty ? metadata.map { "\($0)=\($1)" }.joined(separator: " ") : nil
    }
    
    private func getEnvelopeContent(
        level: Logger.Level,
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
                                   contexts: EnvelopeContext(),
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
                                   contexts: EnvelopeContext(),
                                   message: message,
                                   exception: nil)
        }
    }
    
    private func getServerName() -> String {
        return Host.current().localizedName ?? ""
    }
}
