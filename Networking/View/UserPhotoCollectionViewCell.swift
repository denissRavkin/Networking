//
//  UserPhotoCollectionViewCell.swift
//  Networking
//
//  Created by Denis Ravkin on 04.07.2021.
//

import UIKit

class UserPhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    var photo: Photo?
    
    func configureCell(photo: Photo, imageCache: NSCache<NSString, UIImage>) {
        imageView.image = nil
        guard let imageStringUrl = photo.url else { return }
        self.photo = photo
        if let chachedImage = imageCache.object(forKey: imageStringUrl as NSString) {
            imageView.image = chachedImage
            print("imageView.image = chachedImage")
            return
        }
        DispatchQueue.global(qos: .utility).async {
            guard let imageUrl = URL(string: imageStringUrl ) else {
                print("url failed")
                DispatchQueue.main.async {
                    self.imageView.image = #imageLiteral(resourceName: "???")
                }
                return
            }
            if let imageData = try? Data(contentsOf: imageUrl) {
                DispatchQueue.main.async {
                    if imageStringUrl == self.photo?.url {
                        guard let image = UIImage(data: imageData) else { return }
                        self.imageView.image = image
                        imageCache.setObject(image, forKey: imageStringUrl as NSString)
                    } else {
                        print(imageStringUrl)
                        print(self.photo?.url)
                    }
                }
            }
        }
    }
}
