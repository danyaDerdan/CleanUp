import UIKit
import Photos

protocol RouterProtocol {
    func showMainModule()
    func showDetailModule(with asset: PHAsset)
}

final class Router: RouterProtocol {
    var builder: BuilderProtocol
    var navigationController: UINavigationController
    
    init(builder: BuilderProtocol, navigationController: UINavigationController) {
        self.builder = builder
        self.navigationController = navigationController
    }
    
    func showMainModule() {
        navigationController.viewControllers = [builder.createMainModule(router: self)]
    }
    
    func showDetailModule(with asset: PHAsset) {
        navigationController.present(builder.createDetailModule(with: asset), animated: true)
    }
}
