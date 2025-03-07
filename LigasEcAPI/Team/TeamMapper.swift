//
//  TeamMapper.swift
//  LigasEcAPI
//
//  Created by José Briones on 25/2/25.
//

import Foundation

public final class TeamMapper {
    
    // TODO: Pagination
    struct Root: Codable {
        let teamsResponse: [TeamResponse]
        
        enum CodingKeys: String, CodingKey {
            case teamsResponse = "teams"
        }
        
        var teams: [Team] {
            teamsResponse.compactMap { Team(id: $0.id,
                                    name: $0.name,
                                    shortName: $0.shortName) }
        }
        
        struct TeamResponse: Codable {
            let name, slug, shortName: String
            let userCount: Int
            let nameCode: String
            let type, id: Int
        }
    }


            
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Team] {
        guard response.isOK else {
            throw MapperError.unsuccessfullyResponse
        }
        
        do {
            let root = try JSONDecoder().decode(Root.self, from: data)
            return root.teams
        } catch {
            throw error
        }
    }
}

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}

public enum MapperError: Error {
    case unsuccessfullyResponse
}

public struct Team: Hashable, Identifiable {
    public let id: Int
    public let name: String
    public let shortName: String
    public let logoURL: URL?
    
    public init(id: Int, name: String, shortName: String, logoURL: URL? = nil) {
        self.id = id
        self.name = name
        self.shortName = shortName
        self.logoURL = logoURL
    }
}

