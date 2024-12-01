//
//  PageScreenPresenter.swift
//  Kontur
//
//  Created by Вадим Дзюба on 02.12.2024.
//

import UIKit

final class PageScreenPresenter {
    private var heightValue = false
    private var diametrValue = false
    private var massValue = false
    private var loadValue = false
    private var rocket: RocketDTO
    var selectedRocketTable: RocketTable?
    var selectedRocketCollection: RocketCollection?
    weak var view: PageScreenView?
    
    init(rocket: RocketDTO) {
        self.rocket = rocket
    }
    
    func viewDidLoad(view: PageScreenView) {
        self.view = view
        fetchRocketsfromRaw()
    }
    
    private func fetchRocketsfromRaw() {
        selectedRocketTable = RocketTable(id: rocket.id ?? "",
                                          image: rocket.flickr_images?[0] ?? "",
                                          name: rocket.name ?? "",
                                          firstFlight: formateDate(input: rocket.first_flight ?? ""),
                                          country: formateCountry(input: rocket.country ?? ""),
                                          costPerLaunch: formatToMillions(number: rocket.cost_per_launch ?? 0),
                                          firstStageEngines: String(rocket.first_stage?.engines ?? 0),
                                          firstStageFuel: formatFuelCount(number: rocket.first_stage?.fuel_amount_tons ?? 0),
                                          firstStageBurnTimeSec: formatTime(number: rocket.first_stage?.burn_time_sec ?? 0),
                                          secondStageEngines: String(rocket.second_stage?.engines ?? 0),
                                          secondStageFuel: formatFuelCount(number: rocket.second_stage?.fuel_amount_tons ?? 0),
                                          secondStageBurnTimeSec: formatTime(number: rocket.second_stage?.burn_time_sec ?? 0))
        selectedRocketCollection = RocketCollection(heightMeters: String(rocket.height?.meters ?? 0),
                                                    heightFoots: String(rocket.height?.feet ?? 0),
                                                    diametrMeters: String(rocket.diameter?.meters ?? 0),
                                                    dianetrFoots: String(rocket.diameter?.feet ?? 0),
                                                    massKG: String(rocket.mass?.kg ?? 0),
                                                    massLB: String(rocket.mass?.lb ?? 0),
                                                    payloadKG: String(rocket.payload_weights?[0].kg ?? 0),
                                                    payloadLB: String(rocket.payload_weights?[0].lb ?? 0),
                                                    heightMetric: heightValue ? "ft" : "m",
                                                    dianetrMetric: diametrValue ? "ft" : "m",
                                                    massMetric: massValue ? "lb" : "kg",
                                                    payloadMetric: loadValue ? "lb" : "kg")
        view?.reloadData()
    }
    
    func returnHeight() -> String {
        (heightValue ? selectedRocketCollection?.heightFoots : selectedRocketCollection?.heightMeters) ?? ""
    }
    
    func returnDiametr() -> String {
        (diametrValue ? selectedRocketCollection?.dianetrFoots : selectedRocketCollection?.diametrMeters) ?? ""
    }
    
    func returnMass() -> String {
        (massValue ? selectedRocketCollection?.massLB : selectedRocketCollection?.massKG) ?? ""
    }
    
    func returnLoad() -> String {
        (loadValue ? selectedRocketCollection?.payloadLB : selectedRocketCollection?.payloadKG) ?? ""
    }
    
    func compactBools() -> [Bool] {
        [heightValue, diametrValue, massValue, loadValue]
    }
    
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
}

extension PageScreenPresenter: SwitchCellDelegate {
    func switchCell(numOfSelection: Int) {
        if numOfSelection == 0 {
            heightValue.toggle()
        } else if numOfSelection == 1 {
            diametrValue.toggle()
        } else if numOfSelection == 2 {
            massValue.toggle()
        } else if numOfSelection == 3 {
            loadValue.toggle()
        }
        fetchRocketsfromRaw()
    }
}
