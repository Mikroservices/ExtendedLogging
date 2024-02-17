import Foundation

internal struct EnvelopeContext: Encodable {
    let os: EnvelopeOperatingSystem
    let app: EnvelopeApplication
    let device: EnvelopeDevice
    let runtime: EnvelopeRuntime
    let culture: EnvelopeCulture
    
    init(name: String?, version: String?) {
        self.os = EnvelopeOperatingSystem()
        self.app = EnvelopeApplication(name: name, version: version)
        self.device = EnvelopeDevice()
        self.runtime = EnvelopeRuntime()
        self.culture = EnvelopeCulture()
    }
}
