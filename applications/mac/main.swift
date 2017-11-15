import Foundation
import Cocoa

#if DEBUG
  NSSetUncaughtExceptionHandler { exception in
    debugPrint(exception)
  }
#endif

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
