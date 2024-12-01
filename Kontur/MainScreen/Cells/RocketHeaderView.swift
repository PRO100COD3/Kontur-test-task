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
        label.font = .systemFont(ofSize: 23, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private var buttonAction: (() -> Void)?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(30)
            make.top.equalTo(contentView.snp.top)
        }
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}

