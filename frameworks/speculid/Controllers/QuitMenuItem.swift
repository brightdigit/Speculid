import Cocoa

public class QuitMenuItem: NSMenuItem {
  public init() {
    super.init(title: "Quit", action: #selector(exit(_:)), keyEquivalent: "")
    target = self
  }

  public required init(coder decoder: NSCoder) {
    super.init(coder: decoder)
  }

  @objc public func exit(_ sender: QuitMenuItem) {
    precondition(sender == self)
    Application.current.quit(self)
  }
}
