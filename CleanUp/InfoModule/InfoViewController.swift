import Lottie

import UIKit

final class InfoViewController: UIViewController {
    
    var viewModel: InfoViewModelProtocol?
    private lazy var photoLabel = createPhotoLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        connectToViewModel()
        viewModel?.viewDidLoad()
    }
    
    private func connectToViewModel() {
        viewModel?.updateViewData = { [weak self] (number, string) in
            self?.updateLabel(number: number, string: string)
        }
    }
    
}

private extension InfoViewController {
    func createPhotoLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }
    func createClassicLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: NSRange(location: 6, length: 10))
        label.attributedText = attributedString
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }
    
    func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.text = "Congratulations!"
        return label
    }
    
    private func setupViews() {
        
        createButton()
        
        let infoStack = UIStackView(arrangedSubviews: [photoLabel])
        infoStack.insertArrangedSubview(createAnim(named: "Stars"), at: 0)
        infoStack.axis = .horizontal
        
        let spaceStack = UIStackView(arrangedSubviews: [createClassicLabel("Saved 10 minutes\nusing CleanUp")])
        spaceStack.insertArrangedSubview(createAnim(named: "Clock1"), at: 0)
        spaceStack.axis = .horizontal
        
        let globalStack = UIStackView(arrangedSubviews: [createAnim(named: "Succes") ,createTitleLabel(), infoStack, spaceStack])
        
        globalStack.alignment = .center
        globalStack.distribution = .fillEqually
        globalStack.axis = .vertical
        view.addSubview(globalStack)
        globalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            globalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            globalStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            globalStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            globalStack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
            ])
    }
    
    private func createButton() {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Great", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 24
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            button.heightAnchor.constraint(equalToConstant: 80),
            button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
    }
    
    func updateLabel(number: Int, string: String) {
        let text = "You have deleted\n\(number) Photo  (\(string) MB)"
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: NSRange(location: 17, length: text.count - 27))
        photoLabel.attributedText = attributedText
    }
    
    func createAnim(named: String) -> LottieAnimationView{
        let anim = LottieAnimationView(name: named)
        anim.contentMode = .scaleAspectFit
        anim.loopMode = .loop
        anim.play()
        return anim
    }
    
    @objc private func tapped() {
        viewModel?.tapped()
    }
}
