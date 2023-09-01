//
//  LoginViewController.swift
//  CatMap
//
//  Created by yun on 2023/08/16.
//

import UIKit
import AuthenticationServices

final class LoginViewController: UITableViewController {

    private let viewModel: LoginViewModel

    init(
        with viewModel: LoginViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        let appleLoginButton = ASAuthorizationAppleIDButton()
        appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        appleLoginButton.addTarget(self, action: #selector(didTapAppleLoginButton), for: .touchUpInside)
        
        view.addSubview(appleLoginButton)
        NSLayoutConstraint.activate([
            appleLoginButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            appleLoginButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            appleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc func didTapAppleLoginButton() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
//        request.requestedScopes = [.fullName, .email]
//
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()
        
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential, let identityToken = appleIDCredential.identityToken else { return }
        
        print(identityToken)
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }

}

