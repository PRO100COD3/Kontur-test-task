//
//  SettingsScreen.swift
//  Kontur
//
//  Created by Вадим Дзюба on 25.11.2024.
//

import UIKit
import SnapKit

protocol SwitchCellDelegate: AnyObject {
    func switchCell(numOfSelection: Int)
}

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
    private var switchBools: [Bool]
    weak var switchDelegate: SwitchCellDelegate?
    private let data = [
        ["Высота", "m", "ft"],
        ["Диаметр", "m", "ft"],
        ["Масса", "kg", "lb"],
        ["Полезная нагрузка", "kg", "lb"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupTableView()
    }
    
    init(switchDelegate: SwitchCellDelegate, bools: [Bool]) {
        self.switchDelegate = switchDelegate
        self.switchBools = bools
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        cell.configure(title: data[indexPath.row][0], firstItem: data[indexPath.row][1], secondItem: data[indexPath.row][2], selectIndex: switchBools[indexPath.row])
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
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        switchDelegate?.switchCell(numOfSelection: indexPath.row)
    }
}
