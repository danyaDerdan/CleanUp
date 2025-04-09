import UIKit

class MainViewController: UIViewController {
    
    var viewModel: MainViewModelProtocol?
    var groups: [GroupData.PhotoGroup] = []
    var selectionMode: Bool = false {
        didSet {
            selectButton.setTitle(selectionMode ? "Escape" : "Select", for: .normal)
        }
    }
    private let deleteButton = UIButton()
    private lazy var collectionView = createCollectionView()
    private lazy var countLabel = createCountLabel()
    private lazy var selectButton = createSelectButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        navigationController?.navigationBar.isHidden = true
        connectToViewModel()
        setupDeleteButton()
        updateSelectionCounter()
        selectButton.isHidden = false
    }
    
    private func connectToViewModel() {
        viewModel?.updateViewData = { [weak self] data in
            switch data {
            case .succes(let groups):
                self?.groups = groups;
                self?.updateSelectionCounter()
                self?.collectionView.reloadData();
            case .loading: break
            case .deleted:
                self?.deleteButton.isHidden = true
                self?.countLabel.text = self?.getPhotoLibraryStatus()
            case .failure: break
            }
        }
        viewModel?.viewDidLoad()
    }
    
    func updateSelectionCounter() {
        deleteButton.setTitle("Delete (\(viewModel?.getSelectedCount() ?? 0))", for: .normal)
        deleteButton.isHidden = (viewModel?.getSelectedCount() == 0)
        countLabel.text = getPhotoLibraryStatus()
    }
}

private extension MainViewController {
    func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 40)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(PhotoGroupCell.self, forCellWithReuseIdentifier: "PhotoGroupCell")
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.layer.cornerRadius = 20
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        return collectionView
    }
    
    private func createCountLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = "Similar"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .white
        
        let countLabel = UILabel()
        countLabel.font = .systemFont(ofSize: 16, weight: .medium)
        countLabel.text = "test"
        countLabel.textColor = .white
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, countLabel])
        stack.axis = .vertical
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)
            ])
        stack.alignment = .leading
        
        return countLabel
    }
    
    private func setupDeleteButton() {
        deleteButton.setTitle("Delete (\(viewModel?.getSelectedCount() ?? 0))", for: .normal)
        deleteButton.backgroundColor = .systemCyan
        deleteButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        deleteButton.titleLabel?.textAlignment = .center
        deleteButton.tintColor = .white
        deleteButton.layer.cornerRadius = 24
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        collectionView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            deleteButton.heightAnchor.constraint(equalToConstant: 80),
            deleteButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func createSelectButton() -> UIButton {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Select", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 24
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3)
            ])
        button.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        return button
    }

    @objc private func deleteButtonTapped() {
        viewModel?.deleteButtonTapped() //vc
        updateSelectionCounter()
    }
    
    @objc private func selectButtonTapped() {
        selectionMode.toggle()
        if !selectionMode {
            viewModel?.selectButtonTapped()
            collectionView.reloadData()
        } else {
            collectionView.reloadData()
        }
        updateSelectionCounter()
    }
    
    private func getPhotoLibraryStatus() -> String {
        return "\(viewModel?.getSelectedCount() ?? 0) selected ⚫️ \(groups.count) groups"
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoGroupCell", for: indexPath) as? PhotoGroupCell else { return UICollectionViewCell() }
        cell.configure(with: groups[indexPath.section].assets)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as? SectionHeader else { return UICollectionReusableView() }
        sectionHeader.configure(with: "\(groups[indexPath.section].assets.count) Simillar")
        return sectionHeader
    }
    
}

