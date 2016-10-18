//
//  ClientIdentifier.swift
//  speculid
//
//  Created by Leo Dion on 10/18/16.
//
//

public struct ClientIdentifier: ClientIdentifierDelegate {
  public let clientIdentifier: String
  
  public static var serialNumber : String? {
    let platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice") )
    
    guard platformExpert > 0 else {
      return nil
    }
    
    guard let serialNumber = (IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformSerialNumberKey as CFString, kCFAllocatorDefault, 0).takeUnretainedValue() as? String) else {
      return nil
    }
    
    
    IOObjectRelease(platformExpert)
    
    return serialNumber
  }

  public static func calculateIdentifier () -> String {
    
    
    guard let _clientIdentifier = UserDefaults.standard.string(forKey: "clientIdentifier") else {
      let uuid = UUID()
      UserDefaults.standard.set(uuid.uuidString, forKey: "clientIdentifier")
      return uuid.uuidString
    }
    
    return _clientIdentifier
    
//    NSString *serialNumber = NULL;
//    io_service_t platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"));
    
    let serialNumber = self.serialNumber ?? ""
    
//    
//    if (platformExpert)
//    {
//      serialNumber = (__bridge_transfer NSString *)IORegistryEntryCreateCFProperty(platformExpert, CFSTR(kIOPlatformSerialNumberKey), kCFAllocatorDefault, 0);
//      IOObjectRelease(platformExpert);
//    }
//    
    return [serialNumber,NSUserName()].joined(separator: "").data(using: String.Encoding.utf8)!.base64EncodedString()
//    NSString *userIdentifier = NSUserName();
//    NSString *userOnSystemIdentifier = [NSString stringWithFormat:@"%@%@", serialNumber, userIdentifier];
//    _userIdentifier = [[userOnSystemIdentifier dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
  }
  
  public static let shared = ClientIdentifier()
  
  public init () {
    self.clientIdentifier = ClientIdentifier.calculateIdentifier()
  }
}
