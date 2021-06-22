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
    func updateState(_ state: LoginViewModel.State) {
        switch state {
        case .loading:
            AppLoading.shared.showLoading()
        case .error(let error):
            AppLoading.shared.hideLoading()
            showLoginError(error)
        case .success:
            AppLoading.shared.hideLoading()
            showHomeScreen()
        default:
            AppLoading.shared.hideLoading()
        }
    }
    
    func updateButtonState(_ isValid: Bool) {
        isValid == true ? loginButton.unlock() : loginButton.lock()
    }
}

//MARK: - IBAction
extension LoginViewController {
    @IBAction func didPressLogin(_ sender: Any) {
        view.endEditing(true) // Hide keyboard
        viewModel.login()
    }
    
    @IBAction func didPressRegister(_ sender: Any) {
        showRegisterScreen()
    }
    
    @objc func textChanged(_ textField: UITextField) {
        let text = textField.text
        textField == emailTextField
            ? viewModel.updateEmail(text)
            : viewModel.updatePaswword(text)
    }
}

//MARK: - Dialog & Router
extension LoginViewController {
    func showLoginError(_ error: LoginError) {
        switch error {
        case .invalidEmail,. wrongPassword:
            showErrorDialog(title: "Authentication Failed", message: "Invalid email or password")
        default:
            showErrorDialog(title: "Error", message: "Please try again later.")
        }
    }
    
    func showRegisterScreen() {
        let vc = RegisterViewController.storyboardInstance()
        vc.userCreated = { [weak self] registedEmail in
            self?.emailTextField.text = registedEmail
            self?.viewModel.updateEmail(registedEmail)
        }
        
        AppRouter.shared.present(with: vc)
    }
    
    func showHomeScreen() {
        AppRouter.shared.presentAsRoot(with: AppTabBarController.storyboardInstance())
    }
}

//MARK: - UITextfield Delegate
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
