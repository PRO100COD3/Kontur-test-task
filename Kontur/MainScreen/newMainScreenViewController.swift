//
//  newMainScreenViewController.swift
//  Kontur
//
//  Created by Вадим Дзюба on 30.11.2024.
//

import UIKit
import Kingfisher
import SnapKit

//struct Section {
//    let title: String
//    let buttonAction: (() -> Void)?
//    let rows: [Row]
//}
//
//struct Row {
//    let leftText: String
//    let rightText: String
//}

protocol newMainScreenView: AnyObject {
    func reloadData()
}

final class newMainScreenViewController: UIViewController {
    
    private let presenter: MainScreenPresenter
    private lazy var pageViewControl: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        return pageVC
    }()
//    private lazy var tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.frame = self.view.bounds
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(LaunchesScreenTableViewCell.self, forCellReuseIdentifier: LaunchesScreenTableViewCell.defaultReuseIdentifier)
//        tableView.separatorStyle = .none
//        tableView.backgroundColor = .black
//        return tableView
//    }()
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .white
        return label
    }()
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "gearshape")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector (settingsButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        return button
    }()
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundBlack
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundBlack
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()

    
//    private var sections = [
//        Section(
//            title: "Falcon 1",
//            buttonAction: { print("Настройки Falcon 1") },
//            rows: [
//                Row(leftText: "Первый запуск", rightText: "24 марта 2006"),
//                Row(leftText: "Страна", rightText: "Республика Маршалловы острова"),
//                Row(leftText: "Стоимость запуска", rightText: "$7 млн")
//            ]
//        ),
//        Section(
//            title: "первая ступень",
//            buttonAction: nil,
//            rows: [
//                Row(leftText: "Количество двигателей", rightText: "1"),
//                Row(leftText: "Количество топлива", rightText: "44,3 ton"),
//                Row(leftText: "Время сгорания", rightText: "169 sec")
//            ]
//        )
//    ]
    
    init(presenter: MainScreenPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundBlack
        //        presenter.viewDidLoad(self)
        setupUI()
    }
    
    private func setupUI() {
        setupImage()
        setupBottomView()
        setupLabel()
        setupButton()
        setupPageControl()
    }
    
    private func setupImage(){
        view.addSubview(imageView)
        imageView.snp.makeConstraints { maker in
            maker.leading.trailing.top.equalToSuperview()
        }
    }
    
    private func setupBottomView(){
        
    }
    
    private func setupLabel(){
        
    }
    
    private func setupButton(){
        
    }
    
    private func setupPageControl(){
        
    }
    
    @objc private func settingsButtonTapped() {
        let viewController = SettingsScreenViewController()
        
        viewController.title = "Настройки"
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Закрыть",
            style: .done,
            target: self,
            action: #selector(doneTapped)
        )
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.doneButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.modalPresentationStyle = .pageSheet
        present(navigationController, animated: true, completion: nil)
    }

    @objc private func doneTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension newMainScreenViewController: MainScreenView {
    func reloadData() {
        //        pageControl.numberOfPages = presenter.rockets.count
        //        setupContentView()
        //        scrollViewDidEndDecelerating(scrollView)
    }
}
