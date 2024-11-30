//
//  RocketHeaderView.swift
//  Kontur
//
//  Created by Вадим Дзюба on 30.11.2024.
//

import UIKit
import SnapKit

final class RocketHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "RocketHeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private var buttonAction: (() -> Void)?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .darkGray
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(actionButton)
                        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.top.equalTo(contentView.snp.top).offset(10)
        }
        
        actionButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.top.equalTo(contentView.snp.top).offset(10)

        }
        
        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func configure(title: String, buttonAction: (() -> Void)?) {
        titleLabel.text = title
        self.buttonAction = buttonAction
        actionButton.isHidden = buttonAction == nil
    }
    
    @objc private func buttonTapped() {
        buttonAction?()
    }
}

