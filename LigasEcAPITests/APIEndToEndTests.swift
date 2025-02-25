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
    
    func test_endToEndServerGETImageResult_hasImage() async throws {
        // Act
        let imageData = try await getLeagueImageResult()
        
        // Assert
        XCTAssertFalse(imageData.isEmpty, "Expected non-empty image data")
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
        
    private func getLeagueImageResult(file: StaticString = #file, line: UInt = #line) async throws -> Data {
        let client = ephemeralClient()
        let url = imageServerURL.appendingPathComponent("leagues/243.png")
        
        let (data, response) = try await client.get(from: url)

        return try ImageMapper.map(data, from: response)
    }

    private var leagueServerURL: URL {
        return URL(string: "https://v3.football.api-sports.io")!
    }
    
    private var imageServerURL: URL {
        URL(string: "https://media.api-sports.io/football")!
    }
        
    private func ephemeralClient(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral), apiKey: "c3f7e1d18170e13fe81a3a865b4cf1b3")
        trackForMemoryLeaks(client, file: file, line: line)
        return client
    }
}

func makeLeagueItem() -> League {
    League(id: 243,
        name: "Liga Pro Serie B",
        logoURL: URL(string: "https://media.api-sports.io/football/leagues/243.png")!)
    
}
