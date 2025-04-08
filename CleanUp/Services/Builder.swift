import UIKit

protocol BuilderProtocol {
    func createMainModule() -> UIViewController
}

final class Builder: BuilderProtocol {
    func createMainModule() -> UIViewController {
        let viewModel = MainViewModel()
        let viewController = MainViewController()
        let photoManager = PhotoManager()
        viewModel.photoManager = photoManager
        viewController.viewModel = viewModel
        return viewController
    }
}
