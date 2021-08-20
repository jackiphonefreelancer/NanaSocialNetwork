//
//  CreatePostViewModel.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/22/21.
//

import Foundation
import RxSwift

class CreatePostViewModel: NSObject {
    enum State {
        case none
        case loading
        case error
        case success
    }
    
    // Variables
    let state = BehaviorSubject(value: State.none) // Default - none
    let postButtonState = BehaviorSubject(value: false) // Default - false
    let deleteButtonState = BehaviorSubject(value: false) // Default - false
    
    private var content: String?
    private var image: UIImage?
    
    init(content: String? = nil, image: UIImage? = nil) {
        super.init()
        self.content = content
        self.image = image
    }
}

//MARK: - Business Logic
extension CreatePostViewModel {
    func updateContentText(_ text: String?) {
        self.content = text
        // Text is required, cannot be empty
        guard let content = content, !content.isEmpty else {
            postButtonState.onNext(false)
            return
        }
        postButtonState.onNext(true)
    }
    
    func updateContentImage(_ image: UIImage?) {
        self.image = image
        deleteButtonState.onNext(image != nil)
    }
    
    func createPost() {
        if let image = image {
            // Upload file if it not nil
            uploadImageIfNeeded(image: image)
        } else {
            createPost(with: nil)
        }
    }
}

//MARK: - API
extension CreatePostViewModel {
    func createPost(with imageUrl: URL?) {
        state.onNext(.loading)
        APIManager.shared.createPost(content: content!, imageUrl: imageUrl, completion: { [weak self] error in
            if let _ = error {
                self?.state.onNext(.error)
            } else {
                self?.state.onNext(.success)
            }
        })
    }
    
    func uploadImageIfNeeded(image: UIImage) {
        state.onNext(.loading)
        APIManager.shared.uploadImage(image: image, completion: { [weak self] (url, error) in
            if let url = url {
                self?.createPost(with: url)
            } else {
                self?.state.onNext(.error)
            }
        })
    }
}
