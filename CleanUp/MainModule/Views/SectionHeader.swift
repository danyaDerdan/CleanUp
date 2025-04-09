import UIKit

class SectionHeader: UICollectionReusableView {
    var label = UILabel()
    
    func configure(with title: String) {
        label.text = title
        label.font = .boldSystemFont(ofSize: 30)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
}
