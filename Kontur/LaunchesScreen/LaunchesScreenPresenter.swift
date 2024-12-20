//
//  SecondScreenPresenter.swift
//  Kontur
//
//  Created by Вадим Дзюба on 19.11.2024.
//

import Moya
import UIKit

struct PaginatedResponse<T: Codable>: Codable {
    let docs: [T]
    let totalDocs: Int
    let limit: Int
    let totalPages: Int
    let page: Int
    let pagingCounter: Int
    let hasPrevPage: Bool
    let hasNextPage: Bool
    let prevPage: Int?
    let nextPage: Int?
}

protocol LaunchesScreenPresenter: AnyObject {
    func viewDidLoad(_ view: LaunchesScreenViewController)
    var launch: [LaunchDTO] { get }
}

enum LaunchesScreenPresenterState {
    case initial, loading, failed(Error), data([LaunchDTO])
}

final class LaunchesScreenPresenterImpl {
    private let provider = MoyaProvider<SpaceXAPI>()
    var launch: [LaunchDTO] = []
    private var currentRocker: String
    private weak var view: LaunchesScreenView?
    private var state = LaunchesScreenPresenterState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    init(id: String) {
        self.currentRocker = id
    }
    
    private func stateDidChanged() {
        switch state {
            case .initial:
                assertionFailure("can't move to initial state")
            case .loading:
                fetchLaunchesByRocketID(currentRocker){ [weak self] result in
                    switch result {
                        case .success(let launches):
                            self?.launch = launches
                            self?.state = .data(self?.launch ?? [])
                        case .failure(let error):
                            print("Ошибка: \(error.localizedDescription)")
                    }
                }
                
            case .data(let launch):
                self.launch = launch
                let cellModels = launch.map { launch in
                    LaunchesScreenCellModel(name: launch.name,
                                          date: formatDate(from: launch.date_local) ?? "",
                                          success: launch.success ?? false
                    )
                }
                view?.displayCells(cellModels)
            case .failed(_):
                print("Ошибка загрузки")
        }
    }
    
    private func formatDate(from inputDateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "ru_RU")
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ru_RU")
        outputFormatter.dateFormat = "d MMMM, yyyy"
        
        if let date = inputFormatter.date(from: inputDateString) {
            return outputFormatter.string(from: date)
        } else {
            return nil
        }
    }
    
    
    private func fetchLaunchesByRocketID(_ rocketID: String, completion: @escaping (Result<[LaunchDTO], Error>) -> Void) {
        provider.request(.launchesByRocket(id: rocketID)) { result in
            switch result {
                case .success(let response):
                    do {
                        let responseJSON = try JSONDecoder().decode(PaginatedResponse<LaunchDTO>.self, from: response.data)
                        completion(.success(responseJSON.docs))
                    } catch {
                        print("Ошибка декодирования: \(error)")
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Ошибка сети: \(error)")
                    completion(.failure(error))
            }
        }
    }
}

extension LaunchesScreenPresenterImpl: LaunchesScreenPresenter {
    func viewDidLoad(_ view: LaunchesScreenViewController) {
        self.state = .loading
        self.view = view
    }
}
