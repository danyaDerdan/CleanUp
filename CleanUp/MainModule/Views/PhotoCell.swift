import UIKit
import Photos

final class PhotoCell: UICollectionViewCell {
    var asset: PHAsset?
    var isSelectedCell: Bool = false {
        didSet {
            selectionIndicator.backgroundColor = isSelectedCell ? UIColor.green.withAlphaComponent(0.7) : UIColor.clear
        }
    }
    private let imageView = UIImageView()
    private let selectionIndicator: UIView = {
           let view = UIView()
           view.translatesAutoresizingMaskIntoConstraints = false
           view.layer.borderWidth = 1
           view.layer.borderColor = UIColor.white.cgColor
           view.layer.cornerRadius = 12
           view.clipsToBounds = true
           return view
       }()
    
    private func setupViews() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(selectionIndicator)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectionIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            selectionIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            selectionIndicator.widthAnchor.constraint(equalToConstant: 24),
            selectionIndicator.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(with asset: PHAsset, selectionMode: Bool) {
        setupViews()
        selectionIndicator.isHidden = !selectionMode
        self.asset = asset
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: CGSize(width: 200, height: 200),
            contentMode: .aspectFill,
            options: nil
        ) { [weak self] image, _ in
            self?.imageView.image = image
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        isSelectedCell = false
        asset = nil
        selectionIndicator.backgroundColor = .clear
        selectionIndicator.isHidden = true
    }
}
