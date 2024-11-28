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
    func formateDate(input: String) -> String
    func formateCountry(input: String) -> String
    func formatToMillions(number: Int) -> String
    func formatFuelCount(number: Double) -> NSAttributedString
    func formatTime(number: Int) -> String
    var rockets: [Rocket] { get }
}

enum MainScreenPresenterState {
    case initial, loading, failed(Error), data([Rocket])
}

final class MainScreenPresenterImpl {
    private let provider = MoyaProvider<SpaceXAPI>()
    var rockets: [Rocket] = []
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
                self.rockets = rockets
                view?.reloadData()
            case .failed(_):
                print("Ошибка загрузки")
        }
    }
    
    private func fetchRockets() {
        provider.request(.rockets) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    self?.rockets = try JSONDecoder().decode([Rocket].self, from: response.data)
                    self?.state = .data(self?.rockets ?? [])

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
        outputFormatter.locale = Locale(identifier: "ru_RU")
        outputFormatter.dateFormat = "d MMMM yyyy" 
        let formattedDate = outputFormatter.string(from: date)
        return formattedDate
    }
    
    func viewDidLoad(_ view: MainScreenViewController) {
        self.state = .loading
        self.view = view
    }
}
