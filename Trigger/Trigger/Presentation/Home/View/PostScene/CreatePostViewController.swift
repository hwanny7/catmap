//
//  CreatePostViewController.swift
//  Trigger
//
//  Created by yun on 2023/08/08.
//

import UIKit


@IBDesignable
class CreatePostViewController: UIViewController, UITextFieldDelegate, Alertable {

    private var viewModel: DefaultPostViewModel
    
    init(with viewModel: DefaultPostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = .white
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageCollectionView = ImageCollectionViewController(parentViewController: self, viewModel: viewModel)
        let descriptionTextField = TextFieldWithLabel(title: "자세한 설명")
        let descriptionTextField2 = TextFieldWithLabel(title: "자세한 설명")
        let bottomButton = UIButton()
        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        bottomButton.setTitle("하단 버튼", for: .normal)
        bottomButton.backgroundColor = .blue
        
        
        view.addSubview(scrollView)
        view.addSubview(bottomButton)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(imageCollectionView)
        stackView.addArrangedSubview(descriptionTextField)
        stackView.addArrangedSubview(descriptionTextField2)
        

        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
//            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageCollectionView.heightAnchor.constraint(equalTo: imageCollectionView.widthAnchor, multiplier: 1/5),
            
            descriptionTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/5),
            descriptionTextField2.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
            
            bottomButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            bottomButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])


//        NSLayoutConstraint.activate([
//            bottomButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
//            bottomButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
//            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            bottomButton.heightAnchor.constraint(equalToConstant: 50)
//        ])
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.blue.cgColor
        textField.layer.borderWidth = 1.0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0.0
    }
    
    // 키보드 외부 터치 시 키보드 숨기기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
