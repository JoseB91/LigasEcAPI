//
//  TeamMapper.swift
//  LigasEcAPI
//
//  Created by José Briones on 25/2/25.
//

import Foundation

public final class TeamMapper {
    
    private struct Root: Codable {
        let data: [Datum]

        var teams: [Team] {
            guard let firstData = data.first else { return [] }
            return firstData.rows.compactMap { Team(id: $0.teamID,
                                               name: $0.teamName,
                                               logoURL: $0.teamImagePath)
            }
        }

        enum CodingKeys: String, CodingKey {
            case data = "DATA"
        }
        
        struct Datum: Codable {
            let rows: [Row]

            enum CodingKeys: String, CodingKey {
                case rows = "ROWS"
            }
        }
        
        struct Row: Codable {
            let ranking: Int
            let teamName, teamID: String
            let teamImagePath: URL

            enum CodingKeys: String, CodingKey {
                case ranking = "RANKING"
                case teamName = "TEAM_NAME"
                case teamID = "TEAM_ID"
                case teamImagePath = "TEAM_IMAGE_PATH"
            }
        }

    }


    private struct Root2: Decodable {
        let response: [Response]
        
                            
        struct Response: Codable {
            let team: ResponseTeam
           
            struct ResponseTeam: Codable {
                let id: Int
                let name: String
                let logo: URL
            }
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
    public let id: String
    public let name: String
    public let logoURL: URL
    
    public init(id: String, name: String, logoURL: URL) {
        self.id = id
        self.name = name
        self.logoURL = logoURL
    }
}
