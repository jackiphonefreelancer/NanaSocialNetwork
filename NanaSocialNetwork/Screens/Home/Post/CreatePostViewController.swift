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
    @IBOutlet weak var messageTextView: UITextView!
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
        messageTextView.becomeFirstResponder()
    }
    
    // BindView Model
    func bindViewModel() {
        viewModel.state
            .subscribe { [weak self] state in
                self?.updateState(state)
            }
            .disposed(by: disposeBag)

        viewModel.buttonState
            .subscribe { [weak self] isValid in
                self?.updateButtonState(isValid)
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
    
    func updateButtonState(_ isValid: Bool) {
        postBarButtonItem.isEnabled = isValid
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
    
    @objc func textChanged(_ textView: UITextView) {
        let text = textView.text
        viewModel.updateMessage(text)
    }
}

//MARK: - Dialog
extension CreatePostViewController {
    func showLoginError() {
        showErrorDialog(title: "Error", message: "Please try again later.")
    }
}

//MARK: - UITextfield Delegate
extension CreatePostViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let currentText = textView.text as NSString? {
            let newText = currentText.replacingCharacters(in: range, with: text)
            viewModel.updateMessage(newText)
        }
        return true
    }
}

//MARK: - Storyboard
extension CreatePostViewController {
    static func storyboardInstance() -> CreatePostViewController {
        return UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "CreatePostViewController")
            as! CreatePostViewController
    }
}
