//
//  ImageCollectionViewCell.swift
//  DogAPI
//
//  Created by Rawipas Samoondee on 10/9/2566 BE.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    //MARK Tag Image ^1000 < 2000
    private enum ImageCollectionViewTags : Int {
        case image = 1000
    }
    private var image : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        guard let imageView = self.viewWithTag(ImageCollectionViewTags.image.rawValue) as? UIImageView
        else { return }
        
        self.contentMode = .scaleAspectFit
        self.image = imageView
    }
    
    func setImageView(uiImage: UIImage)
    {
        self.layer.cornerRadius = self.layer.frame.size.height / 2
        self.layer.masksToBounds = true
        self.image.image = uiImage
    }
}
