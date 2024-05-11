//
//  ViewController.swift
//  Combine+MVVM
//
//  Created by 渡邊魁優 on 2024/05/11.
//

import UIKit
import Combine

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var collectionView: UICollectionView!
    let viewModel = QiitaViewModel()
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindViewModel()
        viewModel.fetchItems()
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 150)
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.register(QiitaCell.self, forCellWithReuseIdentifier: "QiitaCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }

    func bindViewModel() {
        viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QiitaCell", for: indexPath) as? QiitaCell else {
            fatalError("Unable to dequeue QiitaCell")
        }
        let item = viewModel.items[indexPath.row]
        cell.titleLabel.text = item.title
        cell.imageView.loadImage(from: item.user.profileImageUrl)
        return cell
    }
}

class QiitaCell: UICollectionViewCell {
    var titleLabel: UILabel!
    var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = UILabel(frame: CGRect(x: 5, y: contentView.bounds.height - 30, width: contentView.bounds.width - 10, height: 25))
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)

        imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: contentView.bounds.width - 10, height: contentView.bounds.height - 35))
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }.resume()
    }
}

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
