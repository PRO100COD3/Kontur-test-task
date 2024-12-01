//
//  RocketFooterView.swift
//  Kontur
//
//  Created by Вадим Дзюба on 01.12.2024.
//

import UIKit
import SnapKit

final class RocketFooterView: UITableViewHeaderFooterView {
    static let identifier = "RocketFooterView"
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        button.setTitle("Посмотреть запуски", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector (bottomButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        return button
    }()
    
    private var rocketName = ""
    private var rocketId = ""
    var buttonAction: ((String, String) -> Void)?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
    
    func configure(name: String, id: String, action: @escaping (String, String) -> Void) {
        rocketName = name
        rocketId = id
        buttonAction = action
    }
    
    @objc private func bottomButtonTapped() {
        buttonAction?(rocketName, rocketId)
    }
}
