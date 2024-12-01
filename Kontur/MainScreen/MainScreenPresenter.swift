//
//  FirstScreenPresenter.swift
//  Kontur
//
//  Created by Вадим Дзюба on 16.11.2024.
//

import Moya
import UIKit

protocol MainScreenPresenter: AnyObject {
    func viewDidLoad(_ view: MainScreenViewController)
    var rawRockets: [RocketDTO] { get }
    var screens: [UIViewController] { get }
}

enum MainScreenPresenterState {
    case initial, loading, failed(Error), data([RocketDTO])
}

final class MainScreenPresenterImpl {
    private let provider = MoyaProvider<SpaceXAPI>()
    private var heightValue = false
    private var diametrValue = false
    private var massValue = false
    private var loadValue = false
    var rawRockets: [RocketDTO] = []
    var screens: [UIViewController] = []
    weak var view: MainScreenView?
    private var state = MainScreenPresenterState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    private func stateDidChanged() {
        switch state {
            case .initial:
                assertionFailure("can't move to initial state")
            case .loading:
                fetchRockets()
            case .data(let rockets):
                self.rawRockets = rockets
                screens = createScreens()
                view?.reloadData()
            case .failed(_):
                print("Ошибка загрузки")
        }
    }
    
    func createScreens() -> [UIViewController]{
        for rocket in rawRockets {
            let newScreenPresenter = PageScreenPresenter(rocket: rocket)
            let newScreen = PageScreenViewController(pagePresenter: newScreenPresenter)
            self.screens.append(newScreen)
        }
        return screens
    }
    
    private func fetchRockets() {
        provider.request(.rockets) { [weak self] result in
            switch result {
                case .success(let response):
                    do {
                        self?.rawRockets = try JSONDecoder().decode([RocketDTO].self, from: response.data)
                        self?.state = .data(self?.rawRockets ?? [])
                    } catch {
                        print("Failed to decode: \(error)")
                    }
                case .failure(let error):
                    print("Request failed: \(error)")
            }
        }
    }
}

extension MainScreenPresenterImpl: MainScreenPresenter {
    func viewDidLoad(_ view: MainScreenViewController) {
        self.state = .loading
        self.view = view
    }
}
