import Foundation

internal struct EnvelopeContext: Encodable {
    let os: EnvelopeOperatingSystem
    let app: EnvelopeApplication
    let device: EnvelopeDevice
    let runtime: EnvelopeRuntime
    let culture: EnvelopeCulture
    
    init() {
        self.os = EnvelopeOperatingSystem()
        self.app = EnvelopeApplication()
        self.device = EnvelopeDevice()
        self.runtime = EnvelopeRuntime()
        self.culture = EnvelopeCulture()
    }
}
