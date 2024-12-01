//
//  SettingsScreenTableViewCell.swift
//  Kontur
//
//  Created by Вадим Дзюба on 29.11.2024.
//

import UIKit
import SnapKit

protocol SettingsScreenTableViewCellDelegate: AnyObject {
    func switchValueChanged(forCell cell: SettingsScreenTableViewCell, selectedIndex: Int)
}


final class SettingsScreenTableViewCell: UITableViewCell {
    static let defaultReuseIdentifier = "CustomTableCell"
    weak var delegate: SettingsScreenTableViewCellDelegate?
    private let titleLabel = UILabel()
    private let customSwitch = UISegmentedControl(items: ["", ""])
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .black
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupLabel()
        setupCustomHeightSwitch()
    }
    
    private func setupLabel() {
        titleLabel.font = .systemFont(ofSize: 20)
        titleLabel.textColor = .white
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalTo(contentView.snp.leading).offset(25)
            make.height.equalTo(40)
        }
    }
    
    private func setupCustomHeightSwitch() {
        customSwitch.selectedSegmentIndex = 0
        customSwitch.backgroundColor = .black
        customSwitch.selectedSegmentTintColor = .white
        let font = UIFont.systemFont(ofSize: 14, weight: .medium)
        customSwitch.setTitleTextAttributes([.foregroundColor: UIColor.white, .font: font], for: .normal)
        customSwitch.setTitleTextAttributes([.foregroundColor: UIColor.black, .font: font], for: .selected)
        customSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        contentView.addSubview(customSwitch)
        customSwitch.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-25)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }
    
    func configure(title: String, firstItem: String, secondItem: String, selectIndex: Bool) {
        customSwitch.setTitle(firstItem, forSegmentAt: 0)
        customSwitch.setTitle(secondItem, forSegmentAt: 1)
        if !selectIndex {
            customSwitch.selectedSegmentIndex = 0
        } else {
            customSwitch.selectedSegmentIndex = 1
        }
        titleLabel.text = title
    }
    
    @objc func switchValueChanged(_ sender: UISegmentedControl) {
        delegate?.switchValueChanged(forCell: self, selectedIndex: sender.selectedSegmentIndex)
    }
}
