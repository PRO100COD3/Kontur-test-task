//
//  SecondScreenViewController.swift
//  Kontur
//
//  Created by Вадим Дзюба on 19.11.2024.
//

import UIKit
import SnapKit

protocol LaunchesScreenView: AnyObject {
    func displayCells(_ cellModels: [LaunchesScreenCellModel])
}

final class LaunchesScreenViewController: UIViewController {
    private let presenter: LaunchesScreenPresenter
    private var cellModels: [LaunchesScreenCellModel] = []
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Нету пусков"
        label.font = .systemFont(ofSize: 25)
        label.isHidden = true
        return label
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = self.view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LaunchesScreenTableViewCell.self, forCellReuseIdentifier: LaunchesScreenTableViewCell.defaultReuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad(self)
        view.backgroundColor = .black
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 18)
        ]
        self.navigationController?.navigationBar.standardAppearance = appearance
        setupUI()
    }
    
    init(title: String, presenter: LaunchesScreenPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupTableView()
        setupEmptyLabel()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(30)
        }
    }
    
    private func setupEmptyLabel() {
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}

extension LaunchesScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return 100
        } else {
            return 10
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 20
        } else {
            cell.backgroundColor = .clear
        }
        
    }
}

extension LaunchesScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellModels.count * 2 - 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LaunchesScreenTableViewCell.defaultReuseIdentifier, for: indexPath) as? LaunchesScreenTableViewCell else {
                return UITableViewCell()
            }
            let cellModel = cellModels[indexPath.row / 2]
            cell.changeCell(with: cellModel)
            cell.accessoryType = .none
            return cell
        } else {
            let spacerCell = UITableViewCell()
            spacerCell.backgroundColor = .clear
            spacerCell.selectionStyle = .none
            return spacerCell
        }
        
    }
}

extension LaunchesScreenViewController: LaunchesScreenView {
    func displayCells(_ cellModels: [LaunchesScreenCellModel]) {
        if cellModels.count == 0 {
            emptyLabel.isHidden = false
        } else {
            emptyLabel.isHidden = true
        }
        self.cellModels = cellModels
        tableView.reloadData()
    }
}
