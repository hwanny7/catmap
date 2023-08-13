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
    func removeImage(_ index: Int)
}

protocol postViewModelOutput {
    var title: String { get }
    var content: String { get }
    var isPublic: Bool { get }
    var imageList: [UIImage] { get }
    var maxPhotoUploadCount: Int { get }
    var canUploadImage: Bool { get }
}


typealias PostViewModel = postViewModelInput & postViewModelOutput


final class DefaultPostViewModel: PostViewModel {
    var title: String = ""
    var content: String = ""
    var isPublic: Bool = true
    var imageList: [UIImage] = [UIImage(systemName: "camera")!]
    
    let photoUploadLimit: Int = 10
    
    var numberOfPhotos: Int {
        return imageList.count - 1
    }
    var maxPhotoUploadCount: Int {
        return photoUploadLimit - numberOfPhotos
    }
    var canUploadImage: Bool {
        return numberOfPhotos != photoUploadLimit ? true : false
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
    func removeImage(_ index: Int) {
        imageList.remove(at: index)
    }
}
