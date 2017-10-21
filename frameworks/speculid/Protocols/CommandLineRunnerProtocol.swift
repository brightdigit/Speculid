import Foundation

public protocol CommandLineRunnerProtocol {
  func activity(withArguments arguments: SpeculidCommandArgumentSet, _ completed: @escaping (CommandLineActivityProtocol, Error?) -> Void) -> CommandLineActivityProtocol
}
