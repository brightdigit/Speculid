import Foundation
import SpeculidKit

extension UserDefaults {
  @objc
  var bookmarks: [String: Data]? {
    get {
      dictionary(forKey: "bookmarks") as? [String: Data]
    }
    set {
      set(newValue, forKey: "bookmarks")
    }
  }
}

public class BookmarkURLCollectionObject: ObservableObject, Sandbox {
  static let shared: UserDefaults = {
    let combined = UserDefaults(suiteName: "MLT7M394S7.group.com.brightdigit.Speculid")!
    combined.register(defaults: ["bookmarks": [String: Data]()])
    return combined
  }()

  @Published var bookmarks = [URL: URL]()

  static func saveBookmark(_ url: URL) {
    guard let newData = try? url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil) else {
      return
    }
    var bookmarkMap = Self.shared.bookmarks ?? [String: Data]()
    bookmarkMap[url.path] = newData
    Self.shared.bookmarks = bookmarkMap
  }

  public func saveBookmark(_ url: URL) {
    Self.saveBookmark(url)
  }

  func reset() {
    Self.shared.bookmarks = [String: Data]()
  }

  func isAvailable(basedOn baseURL: URL?, relativePath: String ...) -> Bool {
    guard let baseURL = baseURL else {
      return false
    }

    var url = baseURL.deletingLastPathComponent()
    for path in relativePath {
      url.appendPathComponent(path)
    }

    return bookmarks[url] != nil
  }

  public func bookmarkURL(fromURL url: URL) throws -> URL {
    var isStale: Bool = false
    let fromURLResult: Result<URL, Error>
    let fromURLCurrentResult = Self.shared.bookmarks?[url.path].map {
      data in
      Result {
        try URL(resolvingBookmarkData: data, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
      }
    }
    if isStale {
      saveBookmark(url)
    }
    fromURLResult = fromURLCurrentResult ?? .failure(NoBookmarkAvailableError(url: url))
    return try fromURLResult.get()
  }

  static func transformPath(_ path: String, withBookmarkData bookmarkData: Data) -> (URL, URL)? {
    var isStale: Bool = false

    guard let url = try? URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale) else {
      return nil
    }

//    if isStale {
//      DispatchQueue.global().async {
//        saveBookmark(url)
//      }
//
//    }
    debugPrint("Adding \(isStale ? "stale" : "fresh") bookmark of \(path) for \(url)")
    return (URL(fileURLWithPath: path), url)
  }

  init() {
    let bookmarkPublisher = Self.shared.publisher(for: \.bookmarks).compactMap { $0 }
    bookmarkPublisher.map {
      Dictionary(uniqueKeysWithValues:
        $0.compactMap(Self.transformPath))
    }.receive(on: DispatchQueue.main).assign(to: &$bookmarks)
  }
}
