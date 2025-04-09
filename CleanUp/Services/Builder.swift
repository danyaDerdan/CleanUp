import UIKit
import Photos

protocol BuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(with photo: PHAsset) -> UIViewController
    func createInfoModule(with assets: [PHAsset], router: RouterProtocol) -> UIViewController
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
    
    func createInfoModule(with assets: [PHAsset], router: RouterProtocol) -> UIViewController {
        let viewModel = InfoViewModel()
        viewModel.assets = assets
        viewModel.router = router
        let viewController = InfoViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
