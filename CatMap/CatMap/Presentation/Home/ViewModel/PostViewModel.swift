//
//  PostViewModel.swift
//  CatMap
//
//  Created by yun on 2023/08/08.
//

import UIKit

struct PostViewModelActions {
    let showMap: (@escaping (Coordinate) -> Void) -> Void
    let dismissMap: () -> Void
}

protocol postViewModelInput {
    func appendImage(_ image: UIImage)
    func removeImage(_ index: Int)
    func didTapLocationButton()
    func didTapRegisterButton()
}

protocol postViewModelOutput {
    var title: String { get }
    var content: String { get }
    var images: [UIImage] { get set }
    var numberOfPhotos: Int { get }
    var maxPhotoUploadCount: Int { get }
    var canUploadImage: Bool { get }
    var photoUploadLimit: Int { get }
    
}


typealias PostViewModel = postViewModelInput & postViewModelOutput


final class DefaultPostViewModel: PostViewModel {
    var title: String = ""
    var content: String = ""
    var images: [UIImage] = [UIImage(systemName: "camera")!]
    
    let photoUploadLimit: Int = 10
    
    var numberOfPhotos: Int {
        return images.count - 1
    }
    var maxPhotoUploadCount: Int {
        return photoUploadLimit - numberOfPhotos
    }
    var canUploadImage: Bool {
        return numberOfPhotos != photoUploadLimit ? true : false
    }
    
    private var coordinate: Coordinate?
    
    private let actions: PostViewModelActions
    
    private let addMarkerUseCase: AddMarkerUseCase
    
    init(
        actions: PostViewModelActions,
        addMarkerUseCase: AddMarkerUseCase
    ) {
        self.actions = actions
        self.addMarkerUseCase = addMarkerUseCase
    }
    
    private func didSetCoordinate(coordinate: Coordinate) {
        actions.dismissMap()
        self.coordinate = coordinate
    }
    
    private func validateForm() {
        // 유효성 검사
        submitForm()
        
    }
    
    private func submitForm() {
        
    }
    
}

// MARK: - Input

extension DefaultPostViewModel {
    func appendImage(_ image: UIImage) {
        images.append(image)
    }
    func removeImage(_ index: Int) {
        images.remove(at: index)
    }
    func didTapLocationButton() {
        actions.showMap(didSetCoordinate(coordinate:))
    }
    func didTapRegisterButton() {
        validateForm()
        // 유효성 검사 메소드 호출, 거기서 use case 호출
//        let post = AddMarkerUseCaseRequestValue(title: title, content: content, images: images, coordinate: coordinate)
    }
}
