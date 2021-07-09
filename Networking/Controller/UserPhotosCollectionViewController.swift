//
//  UserPhotosCollectionViewController.swift
//  Networking
//
//  Created by Denis Ravkin on 04.07.2021.
//

import UIKit

private let reuseIdentifier = "UserPhotoCollectionViewCell"

class UserPhotosCollectionViewController: UICollectionViewController {
    private var photos: [Photo] = []
    private let networkManager: NetworkManager = NetworkManager()
    private var imageCache = NSCache<NSString, UIImage>()
    var userID: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        getPhotos()
    }

    func setupCollectionView() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let sectionInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionViewLayout.sectionInset = sectionInsets
        collectionViewLayout.minimumLineSpacing = 5
        collectionViewLayout.minimumInteritemSpacing = 5
        let itemWidth = (UIScreen.main.bounds.width - sectionInsets.left - sectionInsets.right - collectionViewLayout.minimumLineSpacing)/2
        let itemHeight = itemWidth
        collectionViewLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        collectionView.collectionViewLayout = collectionViewLayout
    }
    
    func getPhotos() {
        guard let userID = userID else { return }
        networkManager.getPhotos(ofUserId: userID) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let photos):
                    self.photos = photos
                    self.collectionView.reloadData()
                case .failure(let error):
                    if let error = error as? HTTPNetworkError {
                        self.showSimpleAlert(title: "Error", message: error.rawValue)
                    } else {
                        self.showSimpleAlert(title: "Error", message: error.localizedDescription)
                    }
                }
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? UserPhotoCollectionViewCell else {
            fatalError("failed to dequeue UserPhotoCollectionViewCell")
        }
        cell.configureCell(photo: photos[indexPath.row], imageCache: imageCache)
    
        return cell
    }
}
