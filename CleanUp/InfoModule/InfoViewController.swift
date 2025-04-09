import UIKit

final class InfoViewController: UIViewController {
    
    var viewModel: InfoViewModelProtocol?
    private lazy var photoLabel = createPhotoLabel()
    private lazy var weightLabel = createClassicLabel("")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        connectToViewModel()
        viewModel?.viewDidLoad()
    }
    
    private func connectToViewModel() {
        viewModel?.updateViewData = { [weak self] (number, string) in
            self?.photoLabel.text = "\(number) Photos"
            self?.weightLabel.text = "(\(string) MB)"
        }
    }
    
}

private extension InfoViewController {
    func createPhotoLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemBlue
        return label
    }
    func createClassicLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = text
        return label
    }
    
    func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = "Congratulations!"
        return label
    }
    
    private func setupViews() {
        let infoStack = UIStackView(arrangedSubviews: [photoLabel, weightLabel])
        infoStack.axis = .horizontal
        let detailStack = UIStackView(arrangedSubviews: [createClassicLabel("You have deleted"), infoStack])
        detailStack.axis = .vertical
        
        let globalStack = UIStackView(arrangedSubviews: [createTitleLabel(), detailStack, createClassicLabel("You saved 10 minutes"), createButton()])
        
        globalStack.alignment = .center
        globalStack.distribution = .fillEqually
        globalStack.axis = .vertical
        view.addSubview(globalStack)
        globalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            globalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            globalStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            globalStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            globalStack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
            ])
    }
    
    private func createButton() -> UIButton {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Great", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 24
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        return button
    }
    
    @objc private func tapped() {
        viewModel?.tapped()
    }
}
