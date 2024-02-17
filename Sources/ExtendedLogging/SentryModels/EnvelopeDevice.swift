import Foundation

internal struct EnvelopeDevice: Encodable {
    let name: String
    let memorySize: UInt64
    let bootTime: Date
    let deviceType = "Desktop"
    
    init() {
        self.name = Host.current().localizedName ?? ""
        self.memorySize = ProcessInfo.processInfo.physicalMemory
        self.bootTime = EnvelopeDevice.getSystemUptime()
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case memorySize = "memory_size"
        case bootTime = "boot_time"
        case deviceType = "device_type"
    }
    
    private static func getSystemUptime() -> Date {
        let uptime = ProcessInfo.processInfo.systemUptime
        return Date(timeIntervalSinceNow: uptime)
    }
}
