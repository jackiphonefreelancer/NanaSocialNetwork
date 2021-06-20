//
//  LoginViewController.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/19/21.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController {

    // IBOutlet
    @IBOutlet weak var emailTextField: AppTextField!
    @IBOutlet weak var passwordTextField: AppTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var inputTextFields: [UITextField]!
    
    // Variables
    private let viewModel = LoginViewModel()
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
        
        // Validate Input
        inputTextFields.forEach { textField in
            textField.addTarget(self, action: #selector(validateInput), for: .editingChanged)
        }
        validateInput()
    }
    
    // BindView Model
    func bindViewModel() {
        viewModel.state
            .subscribe { [weak self] state in
                self?.updateState(state)
            }
            .disposed(by: disposeBag)
    }
    
    // Update State
    func updateState(_ state: LoginViewModel.State) {
        switch state {
        case .loading:
            AppLoading.shared.showLoading()
        case .error(let error):
            AppLoading.shared.hideLoading()
            showLoginError(error)
        default:
            AppLoading.shared.hideLoading()
        }
    }
}

//MARK: - IBAction
extension LoginViewController {
    @IBAction func didPressLogin(_ sender: Any) {
        viewModel.login(with: emailTextField.text!,
                        password: passwordTextField.text!)
    }
    
    @IBAction func didPressRegister(_ sender: Any) {
        
    }
}

//MARK: - Validation
extension LoginViewController {
    @objc func validateInput() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              email.isValidEmail(),
              !password.isEmpty else {
            loginButton.lock()
            return
        }
        loginButton.unlock()
    }
}

//MARK: - Dialog & Update UI
extension LoginViewController {
    func showLoginError(_ error: LoginError) {
        switch error {
        case .invalidEmail,. wrongPassword:
            showErrorDialog(title: "Authentication Failed", message: "Invalid email or password")
        default:
            showErrorDialog(title: "Error", message: "Please try again later.")
        }
    }
}

//MARK: - UITextfield delegate
extension LoginViewController: UITextFieldDelegate {
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
extension LoginViewController {
    static func storyboardInstance() -> LoginViewController {
        return UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
            as! LoginViewController
    }
}
