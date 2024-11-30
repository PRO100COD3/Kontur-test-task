//
//  SettingsScreen.swift
//  Kontur
//
//  Created by Вадим Дзюба on 25.11.2024.
//

import UIKit
import SnapKit

final class SettingsScreenViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = self.view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingsScreenTableViewCell.self, forCellReuseIdentifier: SettingsScreenTableViewCell.defaultReuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        return tableView
    }()

    private let data = [
        ["Высота", "m", "ft"],
        ["Диаметр", "m", "ft"],
        ["Масса", "kg", "lb"],
        ["Полезная нагрузка", "kg", "lb"]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        //        presenter.viewDidLoad(self)
        view.backgroundColor = .black
        setupTableView()
    }
    
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.trailing.equalTo(view.snp.trailing)
            make.leading.equalTo(view.snp.leading)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
}

extension SettingsScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsScreenTableViewCell.defaultReuseIdentifier, for: indexPath) as? SettingsScreenTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.configure(title: data[indexPath.row][0], firstItem: data[indexPath.row][1], secondItem: data[indexPath.row][2])
        return cell
    }
}

extension SettingsScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension SettingsScreenViewController: SettingsScreenTableViewCellDelegate {
    func switchValueChanged(forCell cell: SettingsScreenTableViewCell, selectedIndex: Int) {
        let indexPath = tableView.indexPath(for: cell)
        if indexPath?.row == 0 {
            
        } else if indexPath?.row == 1 {
            
        } else if indexPath?.row == 2 {
            
        } else if indexPath?.row == 3 {
            
        }
    }
}
