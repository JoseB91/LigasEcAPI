//
//  TeamMapper.swift
//  LigasEcAPI
//
//  Created by José Briones on 25/2/25.
//

import Foundation

public final class TeamMapper {
    // TODO: Pagination
    private struct Root: Decodable {
        let response: [Response]
        
        var teams: [Team] {
            response.compactMap { Team(id: $0.team.id,
                                         name: $0.team.name,
                                         logoURL: $0.team.logo)
            }
        }
                            
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
            //print(String(data: data, encoding: .utf8) ?? "No Data")
            let root = try JSONDecoder().decode(Root.self, from: data)
            return root.teams
        } catch {
            throw error
        }
    }
}

public struct Team: Hashable, Identifiable {
    public let id: Int
    public let name: String
    public let logoURL: URL
    
    public init(id: Int, name: String, logoURL: URL) {
        self.id = id
        self.name = name
        self.logoURL = logoURL
    }
}

//"response": [{
//"team": {
//    "id": 33,
//    "name": "Manchester United",
//    "code": "MUN",
//    "country": "England",
//    "founded": 1878,
//    "national": false,
//    "logo": "https://media.api-sports.io/football/teams/33.png"
//},
//"venue":{
//            "id": 556,
//            "name": "Old Trafford",
//            "address": "Sir Matt Busby Way",
//            "city": "Manchester",
//            "capacity": 76212,
//            "surface": "grass",
//            "image": "https://media.api-sports.io/football/venues/556.png"
//        }
//    }]
