//
//  MyPageListViewController.swift
//  CatMap
//
//  Created by yun on 2023/08/07.
//

import UIKit

final class MyPageViewController: UIViewController {

    private let viewModel: MyPageViewModel
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "marker")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let MyPageTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "사용자 아이디"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    init(
        with viewModel: MyPageViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("열린다!")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        view.backgroundColor = .gray
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .blue
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let wrapperStackView = UIStackView()
        wrapperStackView.axis = .vertical
        wrapperStackView.alignment = .center
        wrapperStackView.distribution = .fill
        wrapperStackView.spacing = 16
        wrapperStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(profileImageView)
        stackView.addArrangedSubview(nicknameLabel)
        
        MyPageTableView.delegate = self
        MyPageTableView.dataSource = self
        
        wrapperStackView.addArrangedSubview(stackView)
        wrapperStackView.addArrangedSubview(MyPageTableView)
        scrollView.addSubview(wrapperStackView)
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            wrapperStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            wrapperStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            wrapperStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            wrapperStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            wrapperStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
//            wrapperStackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            
            MyPageTableView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            MyPageTableView.bottomAnchor.constraint(equalTo: wrapperStackView.bottomAnchor),
            MyPageTableView.leadingAnchor.constraint(equalTo: wrapperStackView.leadingAnchor),
            MyPageTableView.trailingAnchor.constraint(equalTo: wrapperStackView.trailingAnchor),
        ])
        
    }
}

extension MyPageViewController: UITableViewDelegate {

}


extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "로그아웃"
        return cell
    }
    
    
}
