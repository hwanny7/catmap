//
//  BaseMapViewModel.swift
//  CatMap
//
//  Created by yun on 2023/08/19.
//

import Foundation



protocol BaseMapViewModelInput {
    
}

protocol BaseMapViewModelOutput {
    
}

typealias BaseMapViewModel = BaseMapViewModelInput & BaseMapViewModelOutput

final class DefaultBaseMapViewModel: BaseMapViewModel {

    
    init() {
        
    }
}

// MARK: - Input view event methods

extension DefaultBaseMapViewModel {

}

// 뷰모델을 자식들이 상속 받게 해서 프로퍼티를 어떻게 오버라이드 할 수 있을까..
