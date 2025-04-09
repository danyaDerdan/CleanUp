import Photos

protocol InfoViewModelProtocol {
    var updateViewData: ((Int, String) -> Void)? { get set }
    func viewDidLoad()
    func tapped()
}

final class InfoViewModel: InfoViewModelProtocol {
    var updateViewData: ((Int, String) -> Void)?
    var assets: [PHAsset]?
    var router: RouterProtocol?
    
    func viewDidLoad() {
        calculateTotalSizeOfAssets(assets ?? []) { [weak self] totalSize in
            self?.updateViewData?(self?.assets?.count ?? 0, String(format: "%.2f", totalSize))
        }
    }
    
    func tapped() {
        router?.popToRoot()
    }
    
    private func calculateTotalSizeOfAssets(_ assets: [PHAsset], completion: @escaping (Double) -> Void) {
        var totalSize: Int64 = 0
        let dispatchGroup = DispatchGroup()
        
        for asset in assets {
            dispatchGroup.enter()
            switch asset.mediaType {
            case .image:
                PHImageManager.default().requestImageDataAndOrientation(for: asset, options: nil) { data, _, _, _ in
                    if let data = data {
                        totalSize += Int64(data.count)
                    }
                    dispatchGroup.leave()
                }
            default: dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            let totalSizeInMB = Double(totalSize) / (1024 * 1024)
            completion(totalSizeInMB)
        }
    }
}
