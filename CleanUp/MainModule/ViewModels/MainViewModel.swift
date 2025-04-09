import Photos

protocol MainViewModelProtocol {
    var updateViewData: ((GroupData) -> Void)? { get set }
    func viewDidLoad()
    func tappedCell(with asset: PHAsset, selected: Bool)
    func selectButtonTapped()
    func deleteButtonTapped()
    func imageTapped(with asset: PHAsset)
    func getSelectedCount() -> Int
}

final class MainViewModel: MainViewModelProtocol {
    var updateViewData: ((GroupData) -> Void)?
    var photoManager: PhotoManagerProtocol?
    var router: RouterProtocol?
    private var selectedAssets: [PHAsset] = []
    
    func viewDidLoad() {
        checkPhotoPermissions()
    }
    
    func tappedCell(with asset: PHAsset, selected: Bool) {
        if selected {
            if let index = selectedAssets.firstIndex(of: asset) { selectedAssets.remove(at: index) }
        } else { selectedAssets.append(asset) }
    }
    
    func getSelectedCount() -> Int {
        return selectedAssets.count
    }
    
    func imageTapped(with asset: PHAsset) {
        router?.showDetailModule(with: asset)
    }
    
    func deleteButtonTapped() {
        PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.deleteAssets(self.selectedAssets as NSFastEnumeration)
            }, completionHandler: { success, error in
                if success {
                    DispatchQueue.main.async { [assets = self.selectedAssets] in
                        self.router?.showInfoModule(with: assets) }
                    self.selectedAssets.removeAll()
                    DispatchQueue.main.async { self.updateViewData?(.deleted) }
                    self.loadPhotos()
                } else {
                    print("Ошибка удаления: \(error?.localizedDescription ?? "")")
                }
            })
    }
    
    func selectButtonTapped() {
        selectedAssets.removeAll()
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


