//
//  ClientIdentifier.swift
//  speculid
//
//  Created by Leo Dion on 10/18/16.
//
//

public struct ClientIdentifier: ClientIdentifierDelegate {
  public static let shared = ClientIdentifier()
  public let clientIdentifier: String

  public static func calculateIdentifier () -> String {
    guard let _clientIdentifier = UserDefaults.standard.string(forKey: "clientIdentifier") else {
      let uuid = UUID()
      UserDefaults.standard.set(uuid.uuidString, forKey: "clientIdentifier")
      return uuid.uuidString
    }
    
    return _clientIdentifier
  }
  
  public init () {
    self.clientIdentifier = ClientIdentifier.calculateIdentifier()
  }
}
