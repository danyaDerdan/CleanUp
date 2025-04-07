import UIKit

protocol BuilderProtocol {
    func createMainModule() -> UIViewController
}

final class Builder: BuilderProtocol {
    func createMainModule() -> UIViewController {
        return MainViewController()
    }
}
