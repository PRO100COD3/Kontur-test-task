//
//  Launch.swift
//  Kontur
//
//  Created by Вадим Дзюба on 19.11.2024.
//

import Foundation

struct Launch: Codable {
    let fairings: Fairings?
    let links: Links
    let staticFireDateUTC: String?
    let staticFireDateUnix: Int?
    let net: Bool
    let window: Int?
    let rocket: String
    let success: Bool?
    let failures: [Failure]
    let details: String?
    let crew: [String]
    let ships: [String]
    let capsules: [String]
    let payloads: [String]
    let launchpad: String
    let flight_number: Int
    let name: String
    let date_utc: String
    let date_unix: Int
    let date_local: String
    let date_precision: String
    let upcoming: Bool
    let cores: [Core]
    let auto_update: Bool
    let tbd: Bool
    let launch_library_id: String?
    let id: String
    
    struct Fairings: Codable {
        let reused: Bool?
        let recovery_attempt: Bool?
        let recovered: Bool?
        let ships: [String]
    }
    
    struct Links: Codable {
        let patch: Patch
        let reddit: Reddit
        let flickr: Flickr
        let presskit: String?
        let webcast: String?
        let youtubeID: String?
        let article: String?
        let wikipedia: String?
        
        struct Patch: Codable {
            let small: String?
            let large: String?
        }
        
        struct Reddit: Codable {
            let campaign: String?
            let launch: String?
            let media: String?
            let recovery: String?
        }
        
        struct Flickr: Codable {
            let small: [String]
            let original: [String]
        }
    }
    
    struct Failure: Codable {
        let time: Int
        let altitude: Int?
        let reason: String
    }
    
    struct Core: Codable {
        let core: String?
        let flight: Int?
        let gridfins: Bool?
        let legs: Bool?
        let reused: Bool?
        let landing_attempt: Bool?
        let landing_success: Bool?
        let landing_type: String?
        let landpad: String?
    }
}
