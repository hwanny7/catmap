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
    func didUpdate(content: String)
}

protocol postViewModelOutput {
    var content: String { get }
    var images: [UIImage] { get set }
    var numberOfPhotos: Int { get }
    var maxPhotoUploadCount: Int { get }
    var canUploadImage: Bool { get }
    var photoUploadLimit: Int { get }
    var isValidated: ValidationError? { get }
}


typealias PostViewModel = postViewModelInput & postViewModelOutput


final class DefaultPostViewModel: PostViewModel {
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
    var isValidated: ValidationError?
    
    private var coordinate: Coordinate?
    
    private let actions: PostViewModelActions
    
    private let addMarkerUseCase: AddMarkerUseCase
    
    private var addMarkerTask: Cancellable?
    
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
        if numberOfPhotos == 0 {
            isValidated = .noPhoto
            return
        }
        guard let _ = coordinate else {
            isValidated = .noLocation
            return
        }
        
//        submitForm()
    }
    
    private func submitForm() {
//        self.loading.value = loading
        guard let coordinate = coordinate else { return }
        addMarkerTask = addMarkerUseCase.execute(
            requestValue: .init(content: content, images: images, coordinate: coordinate)
        ) { [weak self] result in
//            self?.actions 다음페이지로 이동하는 액션 실행
        }
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
    }
    func didUpdate(content: String) {
        self.content = content
    }
}

// MARK: - Validation check description

enum ValidationError {
    case noPhoto
    case noLocation
}
