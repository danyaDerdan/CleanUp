import Photos

protocol DetailViewModelProtocol {
    var updateViewData: ((DetaiData) -> Void)? { get set }
    func viewDidiLoad()
}

final class DetailViewModel: DetailViewModelProtocol {
    var updateViewData: ((DetaiData) -> Void)?
    var asset: PHAsset?
    
    func viewDidiLoad() {
        PHImageManager.default().requestImage(
            for: asset ?? PHAsset(),
            targetSize: .zero,
            contentMode: .aspectFill,
            options: nil
        ) { [weak self] image, _ in
            let data = DetaiData.success(DetaiData.DetailModel(imageData: image?.pngData() ?? Data(), text: self?.getStringDate() ?? ""))
            self?.updateViewData?(data)
        }
    }
    
    private func getStringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        if let date = asset?.creationDate { return "📅 \(dateFormatter.string(from: date))"}
        else { return "📅 Date: Unknowned" }
    }
}
