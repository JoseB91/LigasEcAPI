//
//  APIEndToEndTests.swift
//  LigasEcAPITests
//
//  Created by José Briones on 24/2/25.
//

import XCTest
import SharedAPI
import LigasEcAPI

final class APIEndToEndTests: XCTestCase {

    func test_endToEndServerGETLeagueResult_matchesExpectedLeague() async throws {
        // Act
        let leagues = try await getLeagueResult()
        
        // Assert
        XCTAssertEqual(leagues.count, 4, "Expected 4 leagues")
        XCTAssertEqual(leagues[0], makeLeagueItem())
    }
    
    // MARK: - Helpers
    private func getLeagueResult(file: StaticString = #filePath, line: UInt = #line) async throws -> [League] {
        let client = ephemeralClient()
        let url = leagueServerURL.appendingPathComponent("leagues")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let parameters = ["country": "Ecuador"]
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        let finalUrl = components.url!
        
        let (data, response) = try await client.get(from: finalUrl)
        
        return try LeagueMapper.map(data, from: response)
    }
    
    private var leagueServerURL: URL {
        return URL(string: "https://flashlive-sports.p.rapidapi.com/v1/")!
    }
    
    private var imageServerURL: URL {
        URL(string: "https://media.api-sports.io/football")!
    }
        
    private func ephemeralClient(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral), apiKey: "d319699dffmsh2e7252b38ac2105p14d2b1jsne003798e4ef8")
        trackForMemoryLeaks(client, file: file, line: line)
        return client
    }
}

func makeLeagueItem() -> League {
    League(id: 243,
        name: "Liga Pro Serie B",
        logoURL: URL(string: "https://media.api-sports.io/football/leagues/243.png")!)
    
}
