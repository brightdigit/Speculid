//// swiftlint:disable all
//import Cocoa
//
//let url = URL(string: "https://raw.githubusercontent.com/lansingcodes/www/master/plugins/font-awesome.js")!
//let graphicsPath = URL(fileURLWithPath: "/Users/leo/Documents/Projects/lansingcodes-iOS-app/graphics/font-awesome", isDirectory: true)
//let svgPath = graphicsPath.appendingPathComponent("svgs")
//let speculidPath = graphicsPath.appendingPathComponent("speculid")
//
//let imageSetPath = URL(fileURLWithPath: "/Users/leo/Documents/Projects/lansingcodes-iOS-app/lansingcodes-iOS-app/Image.imageset", isDirectory: true)
//let destinationFolder = URL(fileURLWithPath: "/Users/leo/Documents/Projects/lansingcodes-iOS-app/lansingcodes-iOS-app/Assets.xcassets/Group Icons", isDirectory: true)
//
//var text = try! String(contentsOf: url).split(whereSeparator: { $0.isNewline })
//
//var groups = [String : [String]]()
//
//var names = [String]()
//
//extension String {
//  var kebobCase : String {
//        guard self.count > 0 else { return self }
//        var newString: String = ""
//
//        let uppercase = CharacterSet.uppercaseLetters
//        let first = self.unicodeScalars.first!
//        newString.append(Character(first))
//        for scalar in self.unicodeScalars.dropFirst() {
//            if uppercase.contains(scalar) {
//                newString.append("-")
//            }
//            let character = Character(scalar)
//            newString.append(character)
//        }
//
//    return newString.lowercased()
//    
//  }
//}
//while let line = text.popLast() {
//  guard line.count > 3 else {
//    continue
//  }
//  let urlString = line.substring(from: line.index(line.startIndex, offsetBy: 3))
//  if let urlComponents = URLComponents(string: urlString), let groupName = urlComponents.queryItems?.first(where: {$0.name == "s"})?.value {
//      
//    groups[groupName] = names
//    names.removeAll(keepingCapacity: false)
//  } else {
//    let name = line.components(separatedBy: "fa").map{$0.components(separatedBy: ",")}
//    if name.count > 1 {
//    if let faName = name[1].first {
//      let notLetter = faName.first(where: {
//        !$0.isLetter && !$0.isNumber
//      })
//      if notLetter == nil {
//        
//        names.append(faName.kebobCase)
//      }
//    }
//    }
//  }
//}
//
//let filePairs : [(key : String, value: [String : URL])] = groups.map { (args)  in
//  
//  let iconNames = args.value.reduce([String : URL]()) { (dictionary, key) -> [String : URL] in
//    var dictionary = dictionary
//    
//    dictionary[key] = svgPath.appendingPathComponent(args.key).appendingPathComponent(key).appendingPathExtension("svg")
//    return dictionary
//  }
//  return (key : args.key, value : iconNames)
//}
//
//let files = [String : [String : URL]].init(uniqueKeysWithValues: filePairs)
//
//if FileManager.default.fileExists(atPath: destinationFolder.path) {
//  try! FileManager.default.removeItem(at: destinationFolder)
//  
//}
//
//if FileManager.default.fileExists(atPath: speculidPath.path) {
//  try! FileManager.default.removeItem(at: speculidPath)
//  
//}
//let speculidContents = """
//{
//  "set" : "../../../lansingcodes-iOS-app/Assets.xcassets/Group Icons/%@.imageset",
//  "source" : "../svgs/%@/%@.svg",
//  "geometry" : "32"
//}
//"""
//try! FileManager.default.createDirectory(at: destinationFolder, withIntermediateDirectories: true, attributes: nil)
//try! FileManager.default.createDirectory(at: speculidPath, withIntermediateDirectories: true, attributes: nil)
//for (group, icons) in files {
//  for (name, url) in icons {
//    let setName = "fa" + String(group[group.startIndex])
//    let fullName = [setName,name].joined(separator: ".")
//    try! FileManager.default.copyItem(at: imageSetPath, to: destinationFolder.appendingPathComponent(fullName).appendingPathExtension("imageset"))
//    let speculidJSON = String(format: speculidContents, fullName,group,name)
//    try! speculidJSON.write(to: speculidPath.appendingPathComponent(fullName).appendingPathExtension("speculid"), atomically: true, encoding: .utf8)
//  }
//}
//let contentsJSON = """
//{
//  "info" : {
//    "version" : 1,
//    "author" : "xcode"
//  }
//}
//"""
//try! contentsJSON.write(to: destinationFolder.appendingPathComponent("Contents").appendingPathExtension("json"), atomically: true, encoding: .utf8)
