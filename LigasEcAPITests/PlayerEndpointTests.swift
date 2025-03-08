//
//  PlayerEndpointTests.swift
//  LigasEcAPITests
//
//  Created by José Briones on 8/3/25.
//

import XCTest
import LigasEcAPI

class PlayerEndpointTests: XCTestCase {

    func test_player_endpointURL() {
        let baseURL = URL(string: "https://flashlive-sports.p.rapidapi.com/v1/")!

        let received = PlayerEndpoint.get(sportId: 1,
                                          locale: "es_MX",
                                          teamId: "Wtn9Stg0").url(baseURL: baseURL)
        
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "flashlive-sports.p.rapidapi.com", "host")
        XCTAssertEqual(received.path, "/v1/teams/squad", "path")
        XCTAssertEqual(received.query?.contains("sport_id=1"), true)
        XCTAssertEqual(received.query?.contains("locale=es_MX"), true)
        XCTAssertEqual(received.query?.contains("team_id=Wtn9Stg0"), true)
    }
}
