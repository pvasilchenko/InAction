//
//  GetPhotoData.swift
//  InAction
//
//  Created by Pavel Vasylchenko on 5/21/18.
//  Copyright © 2018 Pavel Vasylchenko. All rights reserved.
//

import Foundation
import UIKit
import Photos


final class PhotoDataConfig {
    
    fileprivate enum LayoutParameters {
        static let itemsCountInRow: CGFloat = 3
        static let padding: CGFloat = 5
    }
    
    var imageArray = [UIImage]()
    
    let imgManager = PHImageManager.default()
    let requestOptions = PHImageRequestOptions()
    let fetchOptions = PHFetchOptions()
    
    var collectionViewWidth = CGFloat()
    
    func setup() {
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    }
    
    func getData() -> [UIImage] {
        self.setup()
        let width = (collectionViewWidth - (LayoutParameters.itemsCountInRow - 1) * LayoutParameters.padding) / LayoutParameters.itemsCountInRow
        if let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions) {
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count {
                    imgManager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: width, height: width), contentMode: .aspectFill, options: requestOptions, resultHandler: {
                        (image, error) in
                        
                            self.imageArray.append(image!)
                        
                        })
                }
            } else {
                print("You have no photos")
            }
        }
        return imageArray
    }
    
    func setPickedImage(_ viewBounds: CGRect, _ index: Int) -> UIImage {
        self.setup()
        var selectedImage = UIImage()
        if let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions) {
            imgManager.requestImage(for: fetchResult.object(at: index), targetSize: CGSize(width: viewBounds.width, height: viewBounds.height), contentMode: .aspectFill, options: requestOptions, resultHandler: {
                (image, error) in
                
                selectedImage = image!
                
            })
        }
        return selectedImage
    }
}
