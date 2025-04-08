import Photos

protocol MainViewModelProtocol {
    var updateViewData: ((GroupData) -> Void)? { get set }
    func viewDidLoad()
}

final class MainViewModel: MainViewModelProtocol {
    var updateViewData: ((GroupData) -> Void)?
    var photoManager: PhotoManagerProtocol?
    
    func viewDidLoad() {
        checkPhotoPermissions()
    }
    
    private func checkPhotoPermissions() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            guard status == .authorized else { self?.checkPhotoPermissions(); return }
            self?.loadPhotos()
        }
    }
    
    private func loadPhotos() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let assets = PHAsset.fetchAssets(with: options)
        var validAssets = [PHAsset]()
        
        assets.enumerateObjects { asset, _, _ in
            if asset.creationDate != nil { // Теперь учитываем фото без локации
                validAssets.append(asset)
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.updateViewData?(.succes(self?.photoManager?.groupAssets(validAssets) ?? []))
        }
    }
}


