//
//  UIImage+Ex.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/23/21.
//

import UIKit

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpegData(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

// MARK: - Caching
let imageCache = NSCache<AnyObject, UIImage>()

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        //contentMode = mode
        // check if you can find url in cache
        if (imageCache.object(forKey: url.absoluteString as String as AnyObject) != nil) {
            self.image = imageCache.object(forKey: url.absoluteString as AnyObject)
        }
        else {
            guard let data = NSData(contentsOf: url),
                  let image = UIImage(data: data as Data) else {
                return
            }
            DispatchQueue.main.async() {
                imageCache.setObject(image, forKey: url.absoluteString as AnyObject)
                self.image = image
            }
        }
    }
    func downloaded(from link: String?, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let urlString = link else { return }
        guard let url = URL(string: urlString) else { return }
        downloaded(from: url, contentMode: mode)
    }
}