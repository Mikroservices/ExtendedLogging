import Foundation
import Logging

public class SingleLineFormatter: LogFormatter {
    public var metadata = Logger.Metadata() {
        didSet {
            self.prettyMetadata = self.prettify(self.metadata)
        }
    }
    
    private var prettyMetadata: String?
    
    public init() {
    }
    
    public func format(label: String,
                       level: Logger.Level,
                       message: Logger.Message,
                       metadata: Logger.Metadata?,
                       file: String, function: String, line: UInt) -> Data? {

        let prettyMetadata = metadata?.isEmpty ?? true
            ? self.prettyMetadata
            : self.prettify(self.metadata.merging(metadata!, uniquingKeysWith: { _, new in new }))

        let message = "\(self.timestamp()) [\(level.name)] (\(label)\(prettyMetadata.map { ", \($0)" } ?? "")): \(message)\n"
        return message.data(using: .utf8)
    }
    
    private func prettify(_ metadata: Logger.Metadata) -> String? {
        return !metadata.isEmpty ? metadata.map { "\($0)=\($1)" }.joined(separator: " ") : nil
    }
    
    private func timestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        return dateFormatter.string(from: Date())
    }
}
