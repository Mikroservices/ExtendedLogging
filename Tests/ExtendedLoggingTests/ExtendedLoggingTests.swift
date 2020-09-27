import XCTest
import Logging
import Foundation
@testable import ExtendedLogging

final class ExtendedLoggingTests: XCTestCase {
    func testFileLoggerShoulCreateFileWithSimpleLog() {
        // Arrange.
        LoggingSystem.bootstrap { label -> LogHandler in
            FileLogger(label: label, path: "tests01.log", level: .debug)
        }
        
        let logger = Logger(label: "mikroservices.mczachurski.dev")

        // Act.
        logger.info("Hello World!")
        
        // Assert.
        let filePath = getFilePathWithDateStamp(fileName: URL(string: "tests01.log")!)
        let fileHandle = try? FileHandle(forReadingFrom: filePath)
        let fileData = fileHandle?.readDataToEndOfFile()
        let content = String(data: fileData!, encoding: .utf8)
        XCTAssertTrue(content!.contains("[INFO] (mikroservices.mczachurski.dev): Hello World!"))
    }
    
    private func getFilePathWithDateStamp(fileName: URL) -> URL {
        var filePath = fileName
        let pathExtension = filePath.pathExtension
        let timeStamp = getTimeStamp()
        
        filePath.deletePathExtension()
        filePath.appendPathExtension(timeStamp + "." + pathExtension)
        
        return filePath
    }
    
    private func getTimeStamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = RollingInteval.day.rawValue
        return dateFormatter.string(from: Date())
    }
}
