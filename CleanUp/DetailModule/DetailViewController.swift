import UIKit

final class DetailViewController: UIViewController {
    var viewModel: DetailViewModelProtocol?
    private lazy var imageView = createImageView()
    private lazy var dateLabel = createDateLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        connectToViewModel()
        viewModel?.viewDidiLoad()
    }
    
    private func connectToViewModel() {
        viewModel?.updateViewData = { [weak self] data in
            switch data {
            case .success(let data):
                self?.imageView.image = UIImage(data: data.imageData)
                self?.dateLabel.text = data.text
            }
        }
    }
}

private extension DetailViewController {
    func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])
        return imageView
    }
    
    func createDateLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
            ])
        return label
    }
}
