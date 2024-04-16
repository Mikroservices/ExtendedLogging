import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

internal class SentryWriter {
    private let dsnUrl: URL
    private let requestQueue = DispatchQueue.init(label: "SentryWriter", qos: .utility)
    
    init?(dsn: String) {
        guard let dsnUrl = SentryWriter.convertToUrl(sentryDsn: dsn) else {
            print("[SentryWriter] Cannot parse Sentry DSN url.")
            return nil
        }
        
        self.dsnUrl = dsnUrl
    }
    
    func write(message: Data?) {
        guard let data = message else {
            print("[SentryWriter] Logged message cannot be nil.")
            return
        }

        self.sendEvent(url: dsnUrl, data: data)
    }
    
    private func sendEvent(url: URL, data: Data) {
        requestQueue.async {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = data

            let task = URLSession.shared.dataTask(with: urlRequest)
            task.resume()
        }
    }
    
    private static func convertToUrl(sentryDsn: String) -> URL? {
        let dsnUrl = URLComponents(string: sentryDsn)
        
        guard let scheme = dsnUrl?.scheme else {
            return nil
        }
        
        guard let host = dsnUrl?.host else {
            return nil
        }
        
        guard let key = dsnUrl?.user else {
            return nil
        }
        
        guard let path = dsnUrl?.path else {
            return nil
        }

        let url = "\(scheme)://\(host)/api\(path)/envelope/?sentry_key=\(key)&sentry_version=7&sentry_client=dev.mczachurski.mikroservices.extended-logging%2F1.0.0"
        
        return URL(string: url)
    }
}
