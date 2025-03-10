//
//  TeamMapperTests.swift
//  LigasEcAPITests
//
//  Created by José Briones on 7/3/25.
//

import XCTest
import LigasEcAPI

final class TeamMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        // Arrange
        let json = "".makeJSON()
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            // Assert
            XCTAssertThrowsError(
                // Act
                try TeamMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        // Arrange
        let invalidJSON = Data("invalid json".utf8)

        // Assert
        XCTAssertThrowsError(
            // Act
            try TeamMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }

    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        // Arrange
        let item = makeTeamItem()
        let jsonString = """
        {\"DATA\":[{\"GROUP_ID\":1,\"GROUP\":\"Main\",\"ROWS\":[{\"RANKING\":1,\"TEAM_QUALIFICATION\":\"q1\",\"TUC\":\"004682\",\"TEAM_NAME\":\"Barcelona SC\",\"TEAM_ID\":\"pCMG6CNp\",\"MATCHES_PLAYED\":3,\"WINS\":3,\"GOALS\":\"8:3\",\"POINTS\":9.0,\"DYNAMIC_COLUMNS_DATA\":[\"3\",\"8:3\",\"9\"],\"PARTICIPANT_ID\":715,\"DYNAMIC_COLUMNS_DATA_LIVE\":null,\"TEAM_IMAGE_PATH\":\"https://www.flashscore.com/res/image/data/nit9vJwS-WErjuywa.png\"}]}]}
"""
        let json = jsonString.makeJSON()

        // Act
        let result = try TeamMapper.map(json,
                                          from: HTTPURLResponse(statusCode: 200))

        // Assert
        XCTAssertEqual(result, [item])
    }

    // MARK: - Helpers

    func makeTeamItem() -> Team {
        Team(id: "pCMG6CNp",
             name: "Barcelona SC",
             logoURL: URL(string: "https://www.flashscore.com/res/image/data/nit9vJwS-WErjuywa.png")!)
    }
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

extension String {
    func makeJSON() -> Data {
        return self.data(using: .utf8)!
    }
}
