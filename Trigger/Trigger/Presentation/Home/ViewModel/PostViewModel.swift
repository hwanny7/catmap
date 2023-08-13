//
//  PostViewModel.swift
//  Trigger
//
//  Created by yun on 2023/08/08.
//

import UIKit

struct PostViewModelActions {
    
}

protocol postViewModelInput {
//    func didSubmit()
    func appendImage(_ image: UIImage)
}

protocol postViewModelOutput {
    var title: String { get }
    var content: String { get }
    var isPublic: Bool { get }
    var imageList: [UIImage] { get }
    var maxPhotoUploadCount: Int { get }
}


typealias PostViewModel = postViewModelInput & postViewModelOutput


final class DefaultPostViewModel: PostViewModel {
    
    var title: String = ""
    var content: String = ""
    var isPublic: Bool = true
    var imageList: [UIImage] = [UIImage(systemName: "camera")!]
    var maxPhotoUploadCount: Int {
        return 11 - imageList.count
    }
    
//    private let actions: PostViewModelActions
//    
//    init(
//        actions: PostViewModelActions
//    ) {
//        self.actions = actions
//    }
    
    func appendImage(_ image: UIImage) {
        imageList.append(image)
    }
}
