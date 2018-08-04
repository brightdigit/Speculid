import Cocoa
import Foundation

#if DEBUG
  NSSetUncaughtExceptionHandler { exception in
    debugPrint(exception)
  }
#endif

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
