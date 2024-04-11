import Foundation
import FirebaseCrashlytics
import FirebaseAnalytics

final class FirebaseReportService {
    static func sendNonCrashError(_ error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
    
    static func sendCustomEvent(_ name: CustomEvents, parameters: [AnyHashable: Any]) {
        let convertedDictionary: [String: NSObject] = parameters.reduce(into: [String: NSObject]()) { result, pair in
            if let key = pair.key as? String, let value = pair.value as? NSObject {
                result[key] = value
            }
        }

        Analytics.logEvent(name.rawValue, parameters: convertedDictionary)
    }
}


enum CustomEvents: String {
    case af_deeplink_metadata
    case af_deeplink
    case fb_deeplink
    case at_tracking
}
