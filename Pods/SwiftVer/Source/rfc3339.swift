import Foundation


/// Parse RFC 3339 date string to NSDate
///
/// :param: rfc3339DateTimeString string with format "yyyy-MM-ddTHH:mm:ssZ"
/// :returns: NSDate, or nil if string cannot be parsed
public func date(forRFC3339DateTimeString rfc3339DateTimeString: String) -> Date? {
    let formatter = getThreadLocalRFC3339DateFormatter()
    return formatter.date(from: rfc3339DateTimeString)
}

/// Generate RFC 3339 date string for an NSDate
///
/// :param: date NSDate
/// :returns: String
public func rfc3339DateTimeStringForDate(_ date: Date) -> String {
    let formatter = getThreadLocalRFC3339DateFormatter()
    return formatter.string(from: date)
}

// Date formatters are not thread-safe, so use a thread-local instance
private func getThreadLocalRFC3339DateFormatter() -> DateFormatter {
    return cachedThreadLocalObjectWithKey(key: "com.brightdigit.getThreadLocalRFC3339DateFormatter") {
        let en_US_POSIX = Locale(identifier: "en_US_POSIX")
        let rfc3339DateFormatter = DateFormatter()
        rfc3339DateFormatter.locale = en_US_POSIX
        rfc3339DateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssXXX"
        rfc3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return rfc3339DateFormatter
    }
}

/// Return a thread-local object, creating it if it has not already been created
///
/// :param: create closure that will be invoked to create the object
/// :returns: object of type T
private func cachedThreadLocalObjectWithKey<T: AnyObject>(key: String, create: () -> T) -> T {
    let threadDictionary = Thread.current.threadDictionary
        if let cachedObject = threadDictionary[key] as? T {
            return cachedObject
        }
        else {
            let newObject = create()
            threadDictionary[key] = newObject
            return newObject
        }
  
}
