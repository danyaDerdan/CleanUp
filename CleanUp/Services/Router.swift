import UIKit

protocol RouterProtocol {
    func showMainModule()
}

final class Router: RouterProtocol {
    var builder: BuilderProtocol
    var navigationController: UINavigationController
    
    init(builder: BuilderProtocol, navigationController: UINavigationController) {
        self.builder = builder
        self.navigationController = navigationController
    }
    
    func showMainModule() {
        navigationController.viewControllers = [builder.createMainModule()]
    }
}
