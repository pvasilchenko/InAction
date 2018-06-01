//
//  collectionViewCell.swift
//  InAction
//
//  Created by Pavel Vasylchenko on 5/16/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation
import UIKit

class LibraryCollectionViewCell: UICollectionViewCell {
 
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    func addPhoto(photo: UIImage) {
        photoImageView.image = photo
    }
    
}
