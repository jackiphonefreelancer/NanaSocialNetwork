//
//  CreatePostViewController.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/22/21.
//

import UIKit
import RxSwift

class CreatePostViewController: UIViewController {

    // IBOutlet
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentImageViewView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    lazy var postBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didPressPost))
    }()
    
    lazy var cancelBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didPressCancel))
    }()
    
    // Variables
    private let viewModel = CreatePostViewModel()
    private let disposeBag = DisposeBag()
    
    var postCreated: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }
    
    // Setup View
    func setupView() {
        // Setup navigation items & title
        title = "Create Post"
        navigationItem.rightBarButtonItem = postBarButtonItem
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        
        // Show keyboard
        contentTextView.becomeFirstResponder()
    }
    
    // BindView Model
    func bindViewModel() {
        viewModel.state
            .subscribe { [weak self] state in
                self?.updateState(state)
            }
            .disposed(by: disposeBag)

        viewModel.postButtonState
            .subscribe { [weak self] isEnabled in
                self?.updatePostButtonState(isEnabled)
            }
            .disposed(by: disposeBag)
        
        viewModel.deleteButtonState
            .subscribe { [weak self] isEnabled in
                self?.updateDeleteButtonState(isEnabled)
            }
            .disposed(by: disposeBag)
    }
    
    // Update State
    func updateState(_ state: CreatePostViewModel.State) {
        switch state {
        case .loading:
            AppLoading.shared.showLoading(in: self)
        case .error:
            AppLoading.shared.hideLoading()
            showLoginError()
        case .success:
            postCreated?()
            AppLoading.shared.hideLoading()
            AppRouter.shared.dismiss()
        default:
            AppLoading.shared.hideLoading()
        }
    }
    
    func updatePostButtonState(_ isValid: Bool) {
        postBarButtonItem.isEnabled = isValid
    }
    
    func updateDeleteButtonState(_ isValid: Bool) {
        deleteButton.isEnabled = isValid
    }
    
    // Update image
    func updateImage(image: UIImage?) {
        contentImageViewView.image = (image == nil) ? UIImage(named: "image_placeholder") : image
        viewModel.updateContentImage(image)
    }
}

//MARK: - IBAction
extension CreatePostViewController {
    @objc func didPressPost(_ sender: Any) {
        view.endEditing(true) // Hide keyboard
        viewModel.createPost()
    }
    
    @objc func didPressCancel(_ sender: Any) {
        AppRouter.shared.dismiss()
    }
    
    @IBAction func didPressCamera(_ sender: Any) {
        showPhotoSelectionActionSheet()
    }
    
    @IBAction func didPressDelete(_ sender: Any) {
        updateImage(image: nil)
    }
}

//MARK: - Dialog - Router
extension CreatePostViewController {
    func showLoginError() {
        showErrorDialog(title: "Error", message: "Please try again later.")
    }
    
    func showPhotoSelectionActionSheet() {
        let title = "Add photo"
        let actionSheetController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        let takePhotoAction: UIAlertAction = UIAlertAction(title: "Take photo", style: .default) { _ in
            self.takePhoto()
        }
        let openGalleryAction: UIAlertAction = UIAlertAction(title: "Open gallery", style: .default) { [unowned self] _ in
            self.openGallery()
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        actionSheetController.addAction(takePhotoAction)
        actionSheetController.addAction(openGalleryAction)
        actionSheetController.addAction(cancelAction)
        if #available(iOS 13.0, *) {
            actionSheetController.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        present(actionSheetController, animated: true, completion: nil)
    }
    
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.modalPresentationStyle = .fullScreen
            picker.delegate = self
            picker.mediaTypes = ["public.image"]
            present(picker, animated: true, completion: nil)
        } else {
            return
        }
    }

    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.mediaTypes = ["public.image"]
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        } else {
            return
        }
    }
}

//MARK: - UITextfield Delegate
extension CreatePostViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let currentText = textView.text as NSString? {
            let newText = currentText.replacingCharacters(in: range, with: text)
            viewModel.updateContentText(newText)
        }
        return true
    }
}

//MARK: - ImagePicker Delegate
extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let originalImage = info[.originalImage] as? UIImage {
            let cropper = PhotoCropperViewController(image: originalImage)
            cropper.canceled = { [unowned picker] vc in
                picker.dismiss(animated: true, completion: nil)
            }
            cropper.finished = { [unowned self] vc, croppedImage in
                vc.dismiss(animated: true, completion: nil)
                self.updateImage(image: originalImage)
            }
            picker.pushViewController(cropper, animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Storyboard
extension CreatePostViewController {
    static func storyboardInstance() -> CreatePostViewController {
        return UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "CreatePostViewController")
            as! CreatePostViewController
    }
}
