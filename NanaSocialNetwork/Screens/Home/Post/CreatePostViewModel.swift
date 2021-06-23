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
}

//MARK: - API
extension CreatePostViewModel {
    func createPost() {
        state.onNext(.loading)
        APIManager.shared.createPost(content: content!, image: nil, completion: { [weak self] error in
            if let _ = error {
                self?.state.onNext(.error)
            } else {
                self?.state.onNext(.success)
            }
        })
    }
}
