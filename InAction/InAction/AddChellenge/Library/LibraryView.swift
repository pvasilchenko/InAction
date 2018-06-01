//
//  libraryView.swift
//  InAction
//
//  Created by Pavel Vasylchenko on 5/22/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation
import UIKit



class LibraryView: UIView {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    public weak var vc: AddChellengeViewController? {
        didSet {
            if isAwaked {
                vc?.setupLibraryView()
            }
        }
    }
    
    let photoSetter = PhotoDataConfig()
    var isAwaked = Bool()
    
    fileprivate enum ReuseIdentifier {
        static let cell = "LibraryCollectionViewCell"
    }

     fileprivate enum LayoutParameters {
        static let itemsCountInRow: CGFloat = 4
        static let padding: CGFloat = 1
        static let sectionInsets = UIEdgeInsets(top: 50.0, left: 1.0, bottom: 50.0, right: 20.0)
    }

    
    var collection = [UIImage]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isAwaked = true
    }
    
    func firstLoad() {
        imageView.image = photoSetter.setPickedImage(imageView.bounds, 0)
    }
}

extension LibraryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.cell, for: indexPath) as! LibraryCollectionViewCell
        cell.addPhoto(photo: collection[indexPath.row])
        return cell
    }
}

extension LibraryView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (collectionView.bounds.size.width - (LayoutParameters.itemsCountInRow + 1) * LayoutParameters.padding) / LayoutParameters.itemsCountInRow
        let paddingSpace = LayoutParameters.sectionInsets.left * (LayoutParameters.itemsCountInRow + 1)
        let availableWidth = (vc?.self.view.frame.width)! - paddingSpace
        let width = availableWidth / LayoutParameters.itemsCountInRow
        return CGSize(width: width, height: width)
    }

    private func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> CGFloat {
        return LayoutParameters.padding
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutParameters.padding
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageView.image = photoSetter.setPickedImage(imageView.bounds, indexPath.row)
    }
}



