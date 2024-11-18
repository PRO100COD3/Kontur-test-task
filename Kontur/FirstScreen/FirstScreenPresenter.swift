//
//  FirstScreenPresenter.swift
//  Kontur
//
//  Created by Вадим Дзюба on 16.11.2024.
//

import Moya
import UIKit

protocol FirstScreenPresenter: AnyObject {
    func viewDidLoad(_ view: FirstScreenViewController)
    func setView(_ view: FirstScreenViewController)
    func didTapWebViewButton()
    func formateDate(input: String) -> String
    func formateCountry(input: String) -> String
    func formatToMillions(number: Int) -> String
    func formatFuelCount(number: Double) -> NSAttributedString
    func formatTime(number: Int) -> String
    var rockets: [Rocket] { get }
}

enum FirstScreenPresenterState {
    case initial, loading, failed(Error), data([Rocket])
}

final class FirstScreenPresenterImpl {
    let provider = MoyaProvider<SpaceXAPI>()
    var rockets: [Rocket] = []
    weak var view: FirstScreenView?
    private var group = DispatchGroup()
    private var state = FirstScreenPresenterState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    private func stateDidChanged() {
        switch state {
            case .initial:
                assertionFailure("can't move to initial state")
            case .loading:
                view?.showLoading()
                group.enter()
                fetchRockets()
                group.leave()
                group.notify(queue: DispatchQueue.main) {
                    self.state = .data(self.rockets)
                }
            case .data(let rockets):
                view?.hideLoading()
                self.rockets = rockets
                view?.reloadData()
            case .failed(_):
                view?.hideLoading()
                print("Ошибка загрузки")
        }
    }
    
    func fetchRockets() {
        group.enter()
        provider.request(.rockets) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    self?.rockets = try JSONDecoder().decode([Rocket].self, from: response.data)
                } catch {
                    print("Failed to decode: \(error)")
                }
            case .failure(let error):
                print("Request failed: \(error)")
            }
            self?.group.leave()
        }
    }
}

extension FirstScreenPresenterImpl: FirstScreenPresenter {
    func formatTime(number: Int) -> String {
        return String("\(number) sec")
    }
    
    func formatFuelCount(number: Double) -> NSAttributedString {
        let formattedNumber = String(format: "%.1f", number).replacingOccurrences(of: ".", with: ",")
        let fullText = "\(formattedNumber) ton"
        let attributedText = NSMutableAttributedString(string: fullText)
        if let numberRange = fullText.range(of: formattedNumber),
           let tonRange = fullText.range(of: "ton") {
            let numberNSRange = NSRange(numberRange, in: fullText)
            let tonNSRange = NSRange(tonRange, in: fullText)
            attributedText.addAttribute(.foregroundColor, value: UIColor.white, range: numberNSRange)
            attributedText.addAttribute(.foregroundColor, value: UIColor.greyText, range: tonNSRange)
        }
        return attributedText
    }
    
    func formatToMillions(number: Int) -> String {
        let millions = (Double(number)) / 1_000_000
        return String(format: "$%.0f млн", millions)
    }
    
    func formateCountry(input: String) -> String {
        if input == "Republic of the Marshall Islands" {
            return "Республика Маршалловы острова"
        } else if input == "United States" {
            return "США"
        }
        return ""
    }
    
    func formateDate(input: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let date = inputFormatter.date(from: input) ?? Date()
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ru_RU") // Русская локаль для месяца
        outputFormatter.dateFormat = "d MMMM yyyy" // Формат для вывода
        let formattedDate = outputFormatter.string(from: date)
        return formattedDate
    }
        
    func setView(_ view: FirstScreenViewController) {
        self.view = view
    }
    
    func didTapWebViewButton() {
//        let webScreen = WebViewScreenViewController()
//        let navController = webScreen.wrapWithNavigationController()
//        navController.modalPresentationStyle = .overCurrentContext
//        view?.present(on: navController)
    }
    
    func viewDidLoad(_ view: FirstScreenViewController) {
        self.state = .loading
        self.view = view
    }
}
