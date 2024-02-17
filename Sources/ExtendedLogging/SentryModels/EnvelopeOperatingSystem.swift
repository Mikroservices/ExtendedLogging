import Foundation

#if canImport(UIKit)
    import UIKit
#endif

#if os(watchOS)
    import WatchKit
#endif

internal struct EnvelopeOperatingSystem: Encodable {
    let name: String
    let version: String
    
    init() {
        self.name = EnvelopeOperatingSystem.getOperatingSystemName()
        self.version = EnvelopeOperatingSystem.getOperatingSystemVersionString()
    }
    
    private static func getOperatingSystemName() -> String {
        #if os(tvOS) || os(visionOS)
            return UIDevice.current.systemName
        #elseif os(watchOS)
            return WKInterfaceDevice.current().systemName
        #elseif os(Linux)
            return "Linux"
        #elseif os(Windows)
            return "Windows"
        #elseif os(macOS)
            return "macOS"
        #elseif os(iOS)
            if underlyingMacOS {
                if #available(iOS 13.0, macOS 10.15, *) { // Mac Catalyst || Mac Designed for iPad
                    // true when a Mac app built with Mac Catalyst or an iOS app running on Apple silicon
                    if ProcessInfo.processInfo.isMacCatalystApp {
                        return "macOS"
                    }
                }
            }
            return UIDevice.current.systemName
        #else
            return "Unknown"
        #endif
    }
    
    private static  func getOperatingSystemVersionString() -> String {
        return ProcessInfo.processInfo.operatingSystemVersionString
    }
}
