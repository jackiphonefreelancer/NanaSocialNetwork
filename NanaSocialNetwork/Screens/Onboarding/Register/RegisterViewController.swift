//
//  RegisterViewController.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/21/21.
//

import UIKit
import RxSwift

class RegisterViewController: UIViewController {

    // IBOutlet
    @IBOutlet weak var emailTextField: AppTextField!
    @IBOutlet weak var passwordTextField: AppTextField!
    @IBOutlet weak var displayNameTextField: AppTextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet var inputTextFields: [UITextField]!
    
    // Variables
    private let viewModel = RegisterViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }
    
    // Setup View
    func setupView() {
        // Update placeholder
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        displayNameTextField.placeholder = "Display name"
        
        // Validate Input
        inputTextFields.forEach { textField in
            textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        }
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
    func updateState(_ state: RegisterViewModel.State) {
        switch state {
        case .loading:
            AppLoading.shared.showLoading(in: self)
        case .error(let error):
            AppLoading.shared.hideLoading()
            showLoginError(error)
        case .success:
            AppLoading.shared.hideLoading()
            AppRouter.shared.dismiss()
        default:
            AppLoading.shared.hideLoading()
        }
    }
    
    func updateButtonState(_ isValid: Bool) {
        isValid == true ? createButton.unlock() : createButton.lock()
    }
}

//MARK: - IBAction
extension RegisterViewController {
    @IBAction func didPressCreate(_ sender: Any) {
        view.endEditing(true) // Hide keyboard
        viewModel.createUser()
    }
    
    @IBAction func didPressClose(_ sender: Any) {
        AppRouter.shared.dismiss()
    }
    
    @objc func textChanged(_ textField: UITextField) {
        let text = textField.text
        switch textField {
        case emailTextField:
            viewModel.updateEmail(text)
        case passwordTextField:
            viewModel.updatePaswword(text)
        case displayNameTextField:
            viewModel.updateDisplayname(text)
        default:
            break
        }
    }
}

//MARK: - Dialog & Router
extension RegisterViewController {
    func showLoginError(_ error: CreateUserError) {
        switch error {
        case .emailAlreadyInUse:
            showErrorDialog(title: "Create User Failed", message: "This email already in use, please signup with another email.")
        case .weakPassword:
            showErrorDialog(title: "Create User Failed", message: "This password is too weak, please use new password.")
        default:
            showErrorDialog(title: "Error", message: "Please try again later.")
        }
    }
}

//MARK: - UITextfield Delegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let idx = inputTextFields.firstIndex(of: textField) else {
            return true
        }
        
        if idx < inputTextFields.count - 1 {
            inputTextFields[idx + 1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

//MARK: - Storyboard
extension RegisterViewController {
    static func storyboardInstance() -> RegisterViewController {
        return UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController")
            as! RegisterViewController
    }
}
