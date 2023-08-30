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
    let showDetail: (Int) -> Void
}

protocol postViewModelInput {
    func appendImage(_ image: UIImage)
    func removeImage(_ index: Int)
    func didTapLocationButton()
    func didTapRegisterButton()
    func didUpdate(content: String)
}

protocol postViewModelOutput {
    var content: String { get set }
    var images: [UIImage] { get set }
    var numberOfPhotos: Int { get }
    var maxPhotoUploadCount: Int { get }
    var canUploadImage: Bool { get }
    var photoUploadLimit: Int { get }
    var isValidated: Observable<ValidationError?> { get set }
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
    var isValidated: Observable<ValidationError?> = Observable(.none)
    
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
        // 일단 .none으로 변경하고 시작해야 할 듯
        if numberOfPhotos == 0 {
            isValidated.value = .noPhoto
            return
        }
        guard let _ = coordinate else {
            isValidated.value = .noLocation
            return
        }
        // Content는 공백 허용
        submitForm()
    }
    
    private func submitForm() {
        actions.showDetail(1)
        // UseCase에서 detail을 받아서 showDetail로 넘겨주기
//        self.loading.value = loading
//        guard let coordinate = coordinate else { return }
//        addMarkerTask = addMarkerUseCase.execute(
//            requestValue: .init(content: content, images: images, coordinate: coordinate)
//        ) { [weak self] result in
//            self?.actions 다음페이지로 이동하는 액션 실행
//        }
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

enum ValidationError: String {
    case noPhoto = "최소 한 장의 사진을 추가해주세요."
    case noLocation = "위치 정보를 추가해주세요."
}
