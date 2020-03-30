import SwiftUI

extension UserDefaults {
  @objc dynamic var count: Int {
    get {
      return self.integer(forKey: "count")
    }
    set {
      self.set(newValue, forKey: "count")
    }
  }
}
class DefaultsObject : ObservableObject {
  let defaults : UserDefaults! = UserDefaults.init(suiteName: "MLT7M394S7.group.com.brightdigit.Speculid")
  
  @Published var count : Int = 0
  
  init () {
    defaults.publisher(for: \.count).assign(to: \DefaultsObject.count, on: self)
  }
}
struct ContentView: View {
  var defaultsObject = DefaultsObject()
  var body: some View {
    Text("\(self.defaultsObject.count)").frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
