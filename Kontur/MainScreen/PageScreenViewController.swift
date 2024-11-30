//
//  PageScreenViewController.swift
//  Kontur
//
//  Created by Вадим Дзюба on 01.12.2024.
//

import UIKit

final class PageScreenViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .white
        return label
    }()
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        let image = UIImage(systemName: "gearshape")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector (settingsButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        return button
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 120)
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .black
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundBlack
        setupUI()
    }
    
    private func setupUI() {
        setupTitle()
        setupButton()
        setupCollectionView()
        setupTableView()
    }
    
    private func setupTitle() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(50)
            make.leading.equalTo(view.snp.leading).offset(30)
        }
    }
    
    private func setupButton() {
        view.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.trailing.equalTo(view.snp.trailing).offset(-30)
        }
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.height.equalTo(150)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
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
