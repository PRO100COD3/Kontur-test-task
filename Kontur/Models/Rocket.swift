//
//  Rocket.swift
//  Kontur
//
//  Created by Вадим Дзюба on 16.11.2024.
//

import Foundation

struct Rocket: Decodable {
    struct Height: Decodable {
        let meters: Double?
        let feet: Double?
    }

    struct Diameter: Decodable {
        let meters: Double?
        let feet: Double?
    }

    struct Mass: Decodable {
        let kg: Int?
        let lb: Int?
    }

    struct FirstStage: Decodable {
        struct Thrust: Decodable {
            let kN: Int?
            let lbf: Int?
        }

        let thrust_sea_level: Thrust?
        let thrust_vacuum: Thrust?
        let reusable: Bool?
        let engines: Int?
        let fuel_amount_tons: Double?
        let burn_time_sec: Int?
    }

    struct SecondStage: Decodable {
        struct Thrust: Decodable {
            let kN: Int?
            let lbf: Int?
        }

        struct Payload: Decodable {
            struct CompositeFairing: Decodable {
                let height: Height?
                let diameter: Diameter?
            }

            let composite_fairing: CompositeFairing?
            let option_1: String?
        }

        let thrust: Thrust?
        let payloads: Payload?
        let reusable: Bool?
        let engines: Int?
        let fuel_amount_tons: Double?
        let burn_time_sec: Int?
    }

    struct Engines: Decodable {
        struct ISP: Decodable {
            let sea_level: Int?
            let vacuum: Int?
        }

        struct Thrust: Decodable {
            let kN: Int?
            let lbf: Int?
        }

        let isp: ISP?
        let thrust_sea_level: Thrust?
        let thrust_vacuum: Thrust?
        let number: Int?
        let type: String?
        let version: String?
        let layout: String?
        let propellant_1: String?
        let propellant_2: String?
        let thrust_to_weight: Double?
    }

    struct LandingLegs: Decodable {
        let number: Int?
        let material: String?
    }

    struct PayloadWeight: Decodable {
        let id: String?
        let name: String?
        let kg: Int?
        let lb: Int?
    }

    let height: Height?
    let diameter: Diameter?
    let mass: Mass?
    let first_stage: FirstStage?
    let second_stage: SecondStage?
    let engines: Engines?
    let landing_legs: LandingLegs?
    let payload_weights: [PayloadWeight]?
    let flickr_images: [String]?
    let name: String?
    let type: String?
    let active: Bool?
    let stages: Int?
    let boosters: Int?
    let cost_per_launch: Int?
    let success_rate_pct: Int?
    let first_flight: String?
    let country: String?
    let company: String?
    let wikipedia: String?
    let description: String?
    let id: String?
}
