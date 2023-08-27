//
//  CreatePostViewController.swift
//  CatMap
//
//  Created by yun on 2023/08/08.
//

import UIKit
import IQKeyboardManagerSwift

@IBDesignable
final class CreatePostViewController: UIViewController, Alertable {

    private var viewModel: PostViewModel
    
    init(with viewModel: PostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind(to: viewModel)
    }
    
    
    private func setupView() {
        view.backgroundColor = .white
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
    
        
        let imageCollectionView = ImageCollectionView(parentViewController: self, viewModel: viewModel)
        let descriptionTextField = TextFieldWithLabelStackView(title: "내용", placeholderText: "게시글 내용을 작성해 주세요.", textType: .view, updateContent: didChange(content:))
        let locationButton = TextFieldWithLabelStackView(title: "장소", placeholderText: "위치 추가", textType: .field)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCoordinateButton))
        locationButton.addGestureRecognizer(tap)

        let bottomButton = UIButton()
        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        bottomButton.setTitle("등록", for: .normal)
        bottomButton.backgroundColor = .blue
        bottomButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        
        
        view.addSubview(scrollView)
        view.addSubview(bottomButton)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(imageCollectionView)
        stackView.addArrangedSubview(locationButton)
        stackView.addArrangedSubview(descriptionTextField)

        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomButton.topAnchor, constant: -8),
            
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            imageCollectionView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1/5),
            descriptionTextField.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 2/5),
            
            bottomButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            bottomButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            bottomButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1/15),
        ])
    }
    
    private func bind(to viewModel: PostViewModel) {
        viewModel.isValidated.observe(on: self) { [weak self] in
            self?.showAlert(for: $0)
        }
    }
    
    @objc private func didTapCoordinateButton() {
        IQKeyboardManager.shared.resignFirstResponder()
        viewModel.didTapLocationButton()
    }
    
    @objc private func didTapRegisterButton() {
        viewModel.didTapRegisterButton()
    }
    
    private func didChange(content: String) {
        viewModel.didUpdate(content: content)
    }
    
    private func showAlert(for validation: ValidationError?) {
        print(validation)
    }
    
}


