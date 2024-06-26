import Foundation
import Logging

public struct FileLogger: LogHandler {
    
    public var metadata = Logger.Metadata() {
        didSet {
            self.logFormatter.metadata = self.metadata
        }
    }

    public var logLevel: Logger.Level = .info        
    private let fileWriter: FileWriter?
    private var logFormatter: LogFormatter
    
    public init(label: String,
                path: String?,
                level: Logger.Level = .debug,
                metadata: Logger.Metadata = [:],
                logFormatter: LogFormatter = SingleLineFormatter(),
                rollingInterval: RollingInteval = .day,
                fileSizeLimitBytes: Int = 10485760) {
        
        if let path {
            self.fileWriter = FileWriter(path: path, rollingInterval: rollingInterval, fileSizeLimitBytes: fileSizeLimitBytes)
        } else {
            self.fileWriter = nil
        }

        self.label = label
        self.logLevel = level
        self.logFormatter = logFormatter        
        
        self.metadata = metadata
        self.logFormatter.metadata = metadata
    }

    public let label: String
    
    public func log(level: Logger.Level,
                    message: Logger.Message,
                    metadata: Logger.Metadata?,
                    file: String,
                    function: String,
                    line: UInt) {
        guard let fileWriter else {
            return
        }
        
        let message = try? self.logFormatter.format(label: self.label,
                                               level: level,
                                               message: message,
                                               metadata: metadata,
                                               file: file,
                                               function: function,
                                               line: line)

        fileWriter.write(message: message)
    }
    
    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return self.metadata[metadataKey]
        }
        set {
            self.metadata[metadataKey] = newValue
        }
    }
    
    // for testing
    public func wait() -> Void {
        fileWriter?.wait()
    }
}
