//
//  PlayerMapperTests.swift
//  LigasEcAPITests
//
//  Created by José Briones on 7/3/25.
//

import XCTest
import LigasEcAPI

final class PlayerMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        // Arrange
        let json = "".makeJSON()
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            // Assert
            XCTAssertThrowsError(
                // Act
                try PlayerMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        // Arrange
        let invalidJSON = Data("invalid json".utf8)

        // Assert
        XCTAssertThrowsError(
            // Act
            try PlayerMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }

    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        // Arrange
        let item = makePlayerItem()
        let jsonString = """
        {\"DATA\":[{\"GROUP_ID\":12,\"GROUP_LABEL\":\"Goalkeepers\",\"ITEMS\":[{\"PLAYER_ID\":\"S0nWKdXm\",\"PLAYER_NAME\":\"Contreras Jose\",\"PLAYER_TYPE_ID\":\"GOALKEEPER\",\"PLAYER_JERSEY_NUMBER\":1,\"PLAYER_FLAG_ID\":205,\"PLAYER_IMAGE_PATH\":\"https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png\"}]}]}
"""
        let json = jsonString.makeJSON()

        // Act
        let result = try PlayerMapper.map(json,
                                          from: HTTPURLResponse(statusCode: 200))

        // Assert
        XCTAssertEqual(result, [item])
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItemsWithoutJerseyNumber() throws {
        // Arrange
        let item = makePlayerItem2()
        let jsonString = """
        {\"DATA\":[{\"GROUP_ID\":12,\"GROUP_LABEL\":\"Goalkeepers\",\"ITEMS\":[{\"PLAYER_ID\":\"S0nWKdXm\",\"PLAYER_NAME\":\"Contreras Jose\",\"PLAYER_TYPE_ID\":\"GOALKEEPER\",\"PLAYER_FLAG_ID\":205,\"PLAYER_IMAGE_PATH\":\"https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png\"}]}]}
"""
        let json = jsonString.makeJSON()

        // Act
        let result = try PlayerMapper.map(json,
                                          from: HTTPURLResponse(statusCode: 200))

        // Assert
        XCTAssertEqual(result, [item])
    }

    // MARK: - Helpers

    func makePlayerItem() -> Player {
        Player(id: "S0nWKdXm",
               name: "Contreras Jose",
               number: 1,
               position: "GOALKEEPER",
               photoURL: URL(string: "https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png")!)
    }
    
    func makePlayerItem2() -> Player {
        Player(id: "S0nWKdXm",
               name: "Contreras Jose",
               number: 0,
               position: "GOALKEEPER",
               photoURL: URL(string: "https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png")!)
    }

}
