//
//  SecondScreenTableViewCell.swift
//  Kontur
//
//  Created by Вадим Дзюба on 19.11.2024.
//

import UIKit
import SnapKit

final class LaunchesScreenTableViewCell: UITableViewCell {
    
    static let defaultReuseIdentifier = "CustomTableCell"
    private let successImage = {
        let image = UIImageView()
        image.tintColor = .white
        return image
    }()
    private let nameLable = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    private let dateLabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Cart.price", comment: "Цена")
        label.textColor = .greyText
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .backgroundBlack
        selectionStyle = .none
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        setupNameLable()
        setupDateLable()
        setupSuccessImage()
    }
    
    private func setupSuccessImage() {
        contentView.addSubview(successImage)
        successImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupNameLable() {
        contentView.addSubview(nameLable)
        nameLable.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }
    }
    
    private func setupDateLable() {
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLable.snp.bottom).inset(-10)
            make.leading.equalToSuperview().inset(20)
        }
    }
    
    func changeCell(with cellModel: LaunchesScreenCellModel){
        nameLable.text = cellModel.name
        dateLabel.text = cellModel.date
        if cellModel.success {
            successImage.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            successImage.image = UIImage(systemName: "xmark.circle.fill")
        }
    }
}
