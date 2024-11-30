//
//  newMainScreenViewController.swift
//  Kontur
//
//  Created by Вадим Дзюба on 30.11.2024.
//

import UIKit
import Kingfisher
import SnapKit

protocol newMainScreenView: AnyObject {
    func reloadData()
}

final class newMainScreenViewController: UIViewController {
    
    private let presenter: MainScreenPresenter
    private lazy var pageViewControl: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageVC.dataSource = self
        pageVC.delegate = self
        return pageVC
    }()
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "dodge")
        return image
    }()
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundBlack
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = pageControllers.count
        control.currentPage = 0
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = .white
        return control
    }()
    private lazy var pageControllers: [UIViewController] = {
        let blueVC = UIViewController()
        blueVC.view.backgroundColor = .blue
        
        let redVC = UIViewController()
        redVC.view.backgroundColor = .red
        
        let greenVC = UIViewController()
        greenVC.view.backgroundColor = .green
        
        return [blueVC, redVC, greenVC]
    }()
    private var currentPageIndex = 0
    
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
        //        presenter.viewDidLoad(self)
        setupUI()
    }
    
    private func setupUI() {
        setupImage()
        setupBottomView()
        setupPageControl()
        setupPageIndicator()
    }
    
    private func setupImage(){
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(400)
        }
    }
    
    private func setupBottomView(){
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(350)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
    }
    
    private func setupPageControl(){
        addChild(pageViewControl)
        bottomView.addSubview(pageViewControl.view)
        pageViewControl.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        pageViewControl.didMove(toParent: self)
        
        if let firstVC = pageControllers.first {
            pageViewControl.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func setupPageIndicator() {
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(bottomView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom)
        }
    }
}

extension newMainScreenViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pageControllers.firstIndex(of: viewController), currentIndex > 0 else {
            return nil
        }
        return pageControllers[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pageControllers.firstIndex(of: viewController), currentIndex < pageControllers.count - 1 else {
            return nil
        }
        return pageControllers[currentIndex + 1]
    }
}

extension newMainScreenViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let visibleController = pageViewController.viewControllers?.first,
              let index = pageControllers.firstIndex(of: visibleController) else {
            return
        }
        currentPageIndex = index
        pageControl.currentPage = index
    }
}

extension newMainScreenViewController: MainScreenView {
    func reloadData() {
        //        pageControl.numberOfPages = presenter.rockets.count
        //        setupContentView()
        //        scrollViewDidEndDecelerating(scrollView)
    }
}


//struct Section {
//    let title: String
//    let buttonAction: (() -> Void)?
//    let rows: [Row]
//}
//
//struct Row {
//    let leftText: String
//    let rightText: String
//}

//    private var sections = [
//        Section(
//            title: "Falcon 1",
//            buttonAction: { print("Настройки Falcon 1") },
//            rows: [
//                Row(leftText: "Первый запуск", rightText: "24 марта 2006"),
//                Row(leftText: "Страна", rightText: "Республика Маршалловы острова"),
//                Row(leftText: "Стоимость запуска", rightText: "$7 млн")
//            ]
//        ),
//        Section(
//            title: "первая ступень",
//            buttonAction: nil,
//            rows: [
//                Row(leftText: "Количество двигателей", rightText: "1"),
//                Row(leftText: "Количество топлива", rightText: "44,3 ton"),
//                Row(leftText: "Время сгорания", rightText: "169 sec")
//            ]
//        )
//    ]
