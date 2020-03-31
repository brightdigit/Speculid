import Foundation

guard let defaults = UserDefaults(suiteName: "MLT7M394S7.group.com.brightdigit.Speculid") else {
  fatalError("No defaults")
}

let count = defaults.integer(forKey: "count")
defaults.set(count + 1, forKey: "count")
