//
//  PageScreenViewController.swift
//  Kontur
//
//  Created by Вадим Дзюба on 01.12.2024.
//

import UIKit

protocol PageScreenView: AnyObject {
    func reloadData()
}

final class PageScreenViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .white
        return label
    }()
    private lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
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
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(HorizontalMenuViewCell.self, forCellWithReuseIdentifier: HorizontalMenuViewCell.identifier)
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(RocketTableViewCell.self, forCellReuseIdentifier: RocketTableViewCell.identifier)
        tableView.register(RocketHeaderView.self, forHeaderFooterViewReuseIdentifier: RocketHeaderView.identifier)
        tableView.register(RocketFooterView.self, forHeaderFooterViewReuseIdentifier: RocketFooterView.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        return tableView
    }()
    private let presenter: PageScreenPresenter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        presenter.viewDidLoad(view: self)
    }
    
    init(pagePresenter: PageScreenPresenter) {
        presenter = pagePresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        titleLabel.text = presenter.selectedRocketTable?.name
    }
    
    private func setupButton() {
        view.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.bottom.equalTo(titleLabel.snp.bottom)
            make.trailing.equalTo(view.snp.trailing).offset(-30)
        }
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.height.equalTo(100)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func settingsButtonTapped() {
        let viewController = SettingsScreenViewController(switchDelegate: presenter, bools: presenter.compactBools())
        
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

extension PageScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalMenuViewCell.identifier, for: indexPath) as? HorizontalMenuViewCell else { return UICollectionViewCell()
        }
        guard let rocket = presenter.selectedRocketCollection else { return UICollectionViewCell() }
        if indexPath.row == 0 {
            cell.configure(with: presenter.returnHeight(), subtitle: "Высота, \(String(describing: rocket.heightMetric))")
        } else if indexPath.row == 1 {
            cell.configure(with: presenter.returnDiametr(), subtitle: "Диаметр, \(String(describing: rocket.dianetrMetric))")
        } else if indexPath.row == 2 {
            cell.configure(with: presenter.returnMass(), subtitle: "Масса, \(String(describing: rocket.massMetric))")
        } else if indexPath.row == 3 {
            cell.configure(with: presenter.returnLoad(), subtitle: "Нагрузка, \(String(describing: rocket.payloadMetric))")
        }
        return cell
    }
}

extension PageScreenViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension PageScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RocketHeaderView.identifier) as? RocketHeaderView else {
            return nil
        }
        if section == 0 {
            return nil
        } else if section == 1 {
            header.configure(title: "первая ступень")
            return header
        } else if section == 2 {
            header.configure(title: "вторая ступень")
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RocketFooterView.identifier) as? RocketFooterView else {
            return nil
        }
        if section == 2 {
            footerView.configure(name: presenter.selectedRocketTable?.name ?? "", id: presenter.selectedRocketTable?.id ?? "") { [weak self] rocketName, rocketId in
                guard let self = self else { return }
                let launchScreenPresenter = LaunchesScreenPresenterImpl(id: rocketId)
                let launchScreen = LaunchesScreenViewController(title: rocketName, presenter: launchScreenPresenter)
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
                self.navigationController?.navigationBar.tintColor = .white
                self.navigationController?.pushViewController(launchScreen, animated: true)
            }
            return footerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 50
        } else {
            return 20
        }
    }
}

extension PageScreenViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RocketTableViewCell.identifier, for: indexPath) as? RocketTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        if indexPath.row == 0 && indexPath.section == 0 {
            cell.configure(leftText: "Первый запуск", rightText: presenter.selectedRocketTable?.firstFlight ?? "")
        } else if indexPath.row == 1 && indexPath.section == 0 {
            cell.configure(leftText: "Страна", rightText: presenter.selectedRocketTable?.country ?? "")
        } else if indexPath.row == 2 && indexPath.section == 0 {
            cell.configure(leftText: "Стоимость запуска", rightText: presenter.selectedRocketTable?.costPerLaunch ?? "")
        } else if indexPath.row == 0 && indexPath.section == 1 {
            cell.configure(leftText: "Количество двигателей", rightText: presenter.selectedRocketTable?.firstStageEngines ?? "")
        } else if indexPath.row == 1 && indexPath.section == 1 {
            cell.configure(leftText: "Количество топлива", rightText: presenter.selectedRocketTable?.firstStageFuel ?? NSAttributedString())
        } else if indexPath.row == 2 && indexPath.section == 1 {
            cell.configure(leftText: "Время сгорания в секундах", rightText: presenter.selectedRocketTable?.firstStageBurnTimeSec ?? "")
        } else if indexPath.row == 0 && indexPath.section == 2 {
            cell.configure(leftText: "Количество двигателей", rightText: presenter.selectedRocketTable?.secondStageEngines ?? "")
        } else if indexPath.row == 1 && indexPath.section == 2 {
            cell.configure(leftText: "Количество топлива", rightText: presenter.selectedRocketTable?.secondStageFuel ?? NSAttributedString())
        } else if indexPath.row == 2 && indexPath.section == 2 {
            cell.configure(leftText: "Время сгорания в секундах", rightText: presenter.selectedRocketTable?.secondStageBurnTimeSec ?? "")
        }
        return cell
    }
}

extension PageScreenViewController: PageScreenView {
    func reloadData() {
        setupUI()
        collectionView.reloadData()
    }
}
