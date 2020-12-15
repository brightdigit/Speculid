import Combine
import SwiftUI

extension UserDefaults {
  @objc dynamic var count: Int {
    get {
      return integer(forKey: "count")
    }
    set {
      set(newValue, forKey: "count")
    }
  }
}

class DefaultsObject: ObservableObject {
  var cancellable: AnyCancellable!
  let defaults: UserDefaults! = UserDefaults(suiteName: "MLT7M394S7.group.com.brightdigit.Speculid")

  @Published var count: Int = 0

  init() {
    cancellable = defaults.publisher(for: \.count).receive(on: DispatchQueue.main).assign(to: \DefaultsObject.count, on: self)
    count = defaults.integer(forKey: "count")
    print(count)
  }
}

struct ContentView: View {
  @ObservedObject var defaultsObject = DefaultsObject()
  var body: some View {
    Text("\(self.defaultsObject.count)").frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
