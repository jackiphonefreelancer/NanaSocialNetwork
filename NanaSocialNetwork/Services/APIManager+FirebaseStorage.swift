//
//  APIManager+FirebaseStorage.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/23/21.
//

import Foundation
import FirebaseStorage

// MARK: - Firebase Storage - Upload Image
extension APIManager {
    /**
     `completion block`: return 2 parameters
     `param 1`: If success return image url, else return nil
     `param 2`: If success return no error, else return error
     **/
    func uploadImage(image: UIImage, completion: @escaping (URL?, Error?) -> Void) {
        let storageRef = storage.reference()
        
        // Data from image with lowest quality
        guard let data = image.jpegData(.lowest) else {
            completion(nil, NSError.unknown)
            return
        }

        // Create a reference to the file you want to upload, currently uses timestamp as filename
        let timestamp = Date().timeIntervalSince1970
        let imageRef = storageRef.child("images/\(timestamp).jpg")

        // Upload the file to the path
        imageRef.putData(data, metadata: nil) { (metadata, error) in
            // You can also access to download URL after upload.
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion(nil, NSError.unknown)
                    return
                }
                completion(downloadURL, nil)
            }
        }
    }
}
