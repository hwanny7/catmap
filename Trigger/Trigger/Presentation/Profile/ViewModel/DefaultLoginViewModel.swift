//
//  DefaultLoginViewModel.swift
//  Trigger
//
//  Created by yun on 2023/08/16.
//


import Foundation

struct LoginViewModelActions {
    
}


protocol LoginViewModelInput {
    
}

protocol LoginViewModelOutput {
    
}

typealias LoginViewModel = LoginViewModelInput & LoginViewModelOutput


final class DefaultLoginViewModel: LoginViewModel {
    
    init() {
        
    }
    
}

