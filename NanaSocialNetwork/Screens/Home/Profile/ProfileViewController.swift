//
//  ProfileViewController.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/22/21.
//

import UIKit
import RxSwift

class ProfileViewController: UIViewController {

    // IBOutlet
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var joinedAtLabel: UILabel!
    
    // Variables
    private let viewModel = ProfileViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }
    
    // Setup View
    func setupView() {
        displayNameLabel.text = viewModel.displayName
        emailLabel.text = viewModel.email
        joinedAtLabel.text = viewModel.joinedAt
    }
    
    // BindView Model
    func bindViewModel() {
        viewModel.logoutState
            .subscribe({ [weak self] result in
                if let success = result.element, success {
                    self?.showLoginScreen()
                } else {
                    self?.showLogoutError()
                }
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - IBAction
extension ProfileViewController {
    @IBAction func didPressLogout(_ sender: Any) {
        viewModel.logout()
    }
}

//MARK: - Dialog & Router
extension ProfileViewController {
    func showLogoutError() {
        showErrorDialog(title: "Logout failed", message: "Please try again later.")
    }
    
    func showLoginScreen() {
        AppRouter.shared.presentAsRoot(with: LoginViewController.storyboardInstance())
    }
}

//MARK: - Storyboard
extension ProfileViewController {
    static func storyboardInstance() -> ProfileViewController {
        return UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController")
            as! ProfileViewController
    }
}
