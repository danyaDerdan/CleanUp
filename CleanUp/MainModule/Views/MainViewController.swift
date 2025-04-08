import UIKit

class MainViewController: UIViewController {
    
    var viewModel: MainViewModelProtocol?
    var groups: [GroupData.PhotoGroup] = []
    private lazy var collectionView = createCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        navigationController?.navigationBar.isHidden = true
        connectToViewModel()
        collectionView.backgroundColor = .white
    }
    
    private func connectToViewModel() {
        viewModel?.updateViewData = { [weak self] data in
            switch data {
            case .succes(let groups): self?.groups = groups; self?.collectionView.reloadData()
            case .loading: break
            case .failure: break
            }
        }
        viewModel?.viewDidLoad()
    }
}

private extension MainViewController {
    func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(PhotoGroupCell.self, forCellWithReuseIdentifier: "PhotoGroupCell")
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
        // Реализация заголовка секции с датой и координатами
        return UICollectionReusableView()
    }
    
}

