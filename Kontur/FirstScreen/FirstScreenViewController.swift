//
//  FirstScreen.swift
//  Kontur
//
//  Created by Вадим Дзюба on 16.11.2024.
//

import UIKit
import Kingfisher
import SnapKit

protocol MainScreenView: AnyObject {
    func reloadData()
}

final class MainScreenViewController: UIViewController {
    
    private let presenter: MainScreenPresenter
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .backgroundBlack
        scrollView.layer.masksToBounds = true
        scrollView.layer.cornerRadius = 25
        scrollView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return scrollView
    }()
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
        return pageControl
    }()
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundBlack
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    init(presenter: MainScreenPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundBlack
        presenter.viewDidLoad(self)
        setupUI()
    }
    
    private func setupUI() {
        setupImageView()
        setupScrollView()
        setupContentView()
        setupPageControl()
    }
    
    private func setupPageControl() {
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(350)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        }
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints { maker in
            maker.leading.trailing.top.equalToSuperview()
        }
    }
    
    private func setupContentView() {
        let pageCount = presenter.rockets.count
        var previousPage: UIView? = nil
        
        for index in 0..<pageCount {
            let pageView = UIView()
            scrollView.addSubview(pageView)
            pageView.snp.makeConstraints { make in
                make.top.bottom.equalTo(scrollView)
                make.width.equalTo(scrollView)
                if let previousPage = previousPage {
                    make.leading.equalTo(previousPage.snp.trailing)
                } else {
                    make.leading.equalTo(scrollView)
                }
            }
            
            if index == pageCount - 1 {
                pageView.snp.makeConstraints { make in
                    make.trailing.equalTo(scrollView)
                }
            }
            
            configurePage(pageView, forIndex: index)
            previousPage = pageView
        }
    }
    
    private func configurePage(_ pageView: UIView, forIndex index: Int) {
        guard index < presenter.rockets.count else { return }
        let rocket = presenter.rockets[index]
        
        let contentScrollView = UIScrollView()
        pageView.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let contentView = UIView()
        contentScrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(pageView)
        }
        
        pageView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(scrollView.snp.height)
            make.top.equalTo(scrollView.snp.top)
            make.leading.equalTo(scrollView.snp.leading).offset(CGFloat(index) * view.frame.width)
        }
        
        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 25)
        titleLabel.textColor = .white
        titleLabel.text = rocket.name
        
        contentView.addSubview(titleLabel)
        titleLabel.text = rocket.name
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(50)
            make.leading.equalTo(contentView.snp.leading).offset(30)
            make.trailing.equalTo(contentView.snp.trailing).offset(-30)
        }
        
        let firstStartLabel = UILabel()
        firstStartLabel.font = .systemFont(ofSize: 15)
        firstStartLabel.text = "Первый запуск"
        firstStartLabel.textColor = .greyText
        let firstStartLabelCount = UILabel()
        firstStartLabelCount.font = .systemFont(ofSize: 15)
        firstStartLabelCount.textColor = .white
        
        let formattedDate = presenter.formateDate(input: rocket.first_flight ?? "")
        firstStartLabelCount.text = formattedDate
        
        contentView.addSubview(firstStartLabel)
        contentView.addSubview(firstStartLabelCount)
        firstStartLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(30)
        }
        firstStartLabelCount.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        let countryLabel = UILabel()
        countryLabel.font = .systemFont(ofSize: 15)
        countryLabel.text = "Страна"
        countryLabel.textColor = .greyText
        let countryLabelCount = UILabel()
        countryLabelCount.font = .systemFont(ofSize: 15)
        countryLabelCount.textColor = .white
        
        countryLabelCount.text = presenter.formateCountry(input: rocket.country ?? "")
        
        contentView.addSubview(countryLabel)
        contentView.addSubview(countryLabelCount)
        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(firstStartLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
        }
        countryLabelCount.snp.makeConstraints { make in
            make.top.equalTo(firstStartLabel.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        let priceLabel = UILabel()
        priceLabel.font = .systemFont(ofSize: 15)
        priceLabel.text = "Стоимость запуска"
        priceLabel.textColor = .greyText
        let priceLabelCount = UILabel()
        priceLabelCount.font = .systemFont(ofSize: 15)
        priceLabelCount.textColor = .white
        
        priceLabelCount.text = presenter.formatToMillions(number: rocket.cost_per_launch ?? 0)
        
        contentView.addSubview(priceLabel)
        contentView.addSubview(priceLabelCount)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(countryLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
        }
        priceLabelCount.snp.makeConstraints { make in
            make.top.equalTo(countryLabel.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        let firstStageLabel = UILabel()
        firstStageLabel.font = .systemFont(ofSize: 23, weight: .semibold)
        firstStageLabel.text = "первая ступень"
        firstStageLabel.textColor = .white
        
        contentView.addSubview(firstStageLabel)
        firstStageLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        let firstStageEngineLabel = UILabel()
        firstStageEngineLabel.font = .systemFont(ofSize: 15)
        firstStageEngineLabel.text = "Количество двигателей"
        firstStageEngineLabel.textColor = .greyText
        let firstStageEngineLabelCount = UILabel()
        firstStageEngineLabelCount.font = .systemFont(ofSize: 15)
        firstStageEngineLabelCount.textColor = .white
        
        firstStageEngineLabelCount.text = String(rocket.first_stage?.engines ?? 0)
        
        contentView.addSubview(firstStageEngineLabel)
        contentView.addSubview(firstStageEngineLabelCount)
        firstStageEngineLabel.snp.makeConstraints { make in
            make.top.equalTo(firstStageLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
        }
        firstStageEngineLabelCount.snp.makeConstraints { make in
            make.top.equalTo(firstStageLabel.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        let firstStageFuelLabel = UILabel()
        firstStageFuelLabel.font = .systemFont(ofSize: 15)
        firstStageFuelLabel.text = "Количество топлива"
        firstStageFuelLabel.textColor = .greyText
        let firstStageFuelLabelCount = UILabel()
        firstStageFuelLabelCount.font = .systemFont(ofSize: 15)
        firstStageFuelLabelCount.textColor = .white
        
        firstStageFuelLabelCount.attributedText = presenter.formatFuelCount(number: rocket.first_stage?.fuel_amount_tons ?? 0)
        
        contentView.addSubview(firstStageFuelLabel)
        contentView.addSubview(firstStageFuelLabelCount)
        firstStageFuelLabel.snp.makeConstraints { make in
            make.top.equalTo(firstStageEngineLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
        }
        firstStageFuelLabelCount.snp.makeConstraints { make in
            make.top.equalTo(firstStageEngineLabel.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        let firstStageTimeLabel = UILabel()
        firstStageTimeLabel.font = .systemFont(ofSize: 15)
        firstStageTimeLabel.text = "Время сгорания"
        firstStageTimeLabel.textColor = .greyText
        let firstStageTimeLabelCount = UILabel()
        firstStageTimeLabelCount.font = .systemFont(ofSize: 15)
        firstStageTimeLabelCount.textColor = .white
        
        firstStageTimeLabelCount.text = presenter.formatTime(number: rocket.first_stage?.burn_time_sec ?? 0)
        
        contentView.addSubview(firstStageTimeLabel)
        contentView.addSubview(firstStageTimeLabelCount)
        firstStageTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(firstStageFuelLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
        }
        firstStageTimeLabelCount.snp.makeConstraints { make in
            make.top.equalTo(firstStageFuelLabel.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        let secondStageLabel = UILabel()
        secondStageLabel.font = .systemFont(ofSize: 23, weight: .semibold)
        secondStageLabel.text = "вторая ступень"
        secondStageLabel.textColor = .white
        
        contentView.addSubview(secondStageLabel)
        secondStageLabel.snp.makeConstraints { make in
            make.top.equalTo(firstStageTimeLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        let secondStageEngineLabel = UILabel()
        secondStageEngineLabel.font = .systemFont(ofSize: 15)
        secondStageEngineLabel.text = "Количество двигателей"
        secondStageEngineLabel.textColor = .greyText
        let secondStageEngineLabelCount = UILabel()
        secondStageEngineLabelCount.font = .systemFont(ofSize: 15)
        secondStageEngineLabelCount.textColor = .white
        
        secondStageEngineLabelCount.text = String(rocket.second_stage?.engines ?? 0)
        
        contentView.addSubview(secondStageEngineLabel)
        contentView.addSubview(secondStageEngineLabelCount)
        secondStageEngineLabel.snp.makeConstraints { make in
            make.top.equalTo(secondStageLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
        }
        secondStageEngineLabelCount.snp.makeConstraints { make in
            make.top.equalTo(secondStageLabel.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        let secondStageFuelLabel = UILabel()
        secondStageFuelLabel.font = .systemFont(ofSize: 15)
        secondStageFuelLabel.text = "Количество топлива"
        secondStageFuelLabel.textColor = .greyText
        let secondStageFuelLabelCount = UILabel()
        secondStageFuelLabelCount.font = .systemFont(ofSize: 15)
        secondStageFuelLabelCount.textColor = .white
        
        secondStageFuelLabelCount.attributedText = presenter.formatFuelCount(number: rocket.second_stage?.fuel_amount_tons ?? 0)
        
        contentView.addSubview(secondStageFuelLabel)
        contentView.addSubview(secondStageFuelLabelCount)
        secondStageFuelLabel.snp.makeConstraints { make in
            make.top.equalTo(secondStageEngineLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
        }
        secondStageFuelLabelCount.snp.makeConstraints { make in
            make.top.equalTo(secondStageEngineLabel.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        let secondStageTimeLabel = UILabel()
        secondStageTimeLabel.font = .systemFont(ofSize: 15)
        secondStageTimeLabel.text = "Время сгорания"
        secondStageTimeLabel.textColor = .greyText
        let secondStageTimeLabelCount = UILabel()
        secondStageTimeLabelCount.font = .systemFont(ofSize: 15)
        secondStageTimeLabelCount.textColor = .white
        
        secondStageTimeLabelCount.text = presenter.formatTime(number: rocket.second_stage?.burn_time_sec ?? 0)
        
        contentView.addSubview(secondStageTimeLabel)
        contentView.addSubview(secondStageTimeLabelCount)
        secondStageTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(secondStageFuelLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
        }
        secondStageTimeLabelCount.snp.makeConstraints { make in
            make.top.equalTo(secondStageFuelLabel.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        let button = UIButton(type: .system)
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        button.setTitle("Посмотреть запуски", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector (bottomButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        
        
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(secondStageTimeLabelCount.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        let lastElement = button
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(lastElement.snp.bottom).offset(30)
        }
    }
    
    private func updateDataForPage(_ page: Int) {
        guard page < presenter.rockets.count else { return }
        let rocket = presenter.rockets[page]
        imageView.kf.setImage(with: URL(string: rocket.flickr_images?[0] ?? ""))
    }
    
    @objc private func pageControlValueChanged(_ sender: UIPageControl) {
        let page = sender.currentPage
        let xOffset = scrollView.frame.width * CGFloat(page)
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
        updateDataForPage(page)
    }
    
    @objc private func bottomButtonTapped() {
        let secondScreenPresenter = LaunchesScreenPresenterImpl(id: presenter.rockets[pageControl.currentPage].id ?? "")
        let secondScreen = LaunchesScreenViewController(title: presenter.rockets[pageControl.currentPage].name ?? "", presenter: secondScreenPresenter)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.pushViewController(secondScreen, animated: true)
    }
}

extension MainScreenViewController: MainScreenView {
    func reloadData() {
        pageControl.numberOfPages = presenter.rockets.count
        setupContentView()
        scrollViewDidEndDecelerating(scrollView)
    }
}

extension MainScreenViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = page
        updateDataForPage(page)
    }
}

