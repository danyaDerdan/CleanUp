import UIKit
import Photos

protocol BuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(with photo: PHAsset) -> UIViewController
}

final class Builder: BuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let viewModel = MainViewModel()
        let viewController = MainViewController()
        let photoManager = PhotoManager()
        viewModel.photoManager = photoManager
        viewModel.router = router
        viewController.viewModel = viewModel
        return viewController
    }
    
    func createDetailModule(with photo: PHAsset) -> UIViewController {
        let viewModel = DetailViewModel()
        viewModel.asset = photo
        let viewController = DetailViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
