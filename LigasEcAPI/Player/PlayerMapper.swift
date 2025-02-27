//
//  PlayerMapper.swift
//  LigasEcAPI
//
//  Created by José Briones on 26/2/25.
//

import Foundation

public final class PlayerMapper {
    // TODO: Pagination
    private struct Root: Decodable {
        let response: [Response]
        
        var squad: [Player] {
            guard let firtResponse = response.first else { return [] }
            return firtResponse.players.compactMap {
                Player(id: $0.id,
                       name: $0.name,
                       age: $0.age,
                       number: $0.number ?? 0,
                       position: $0.position,
                       photoURL: $0.photo)
            }
        }
                            
        struct Response: Codable {
            let team: ResponseTeam
            let players: [ResponsePlayer]
            struct ResponseTeam: Codable {
                let id: Int
                let name: String
                let logo: URL
            }
            
            struct ResponsePlayer: Codable {
                let id: Int
                let name: String
                let age: Int
                let number: Int?
                let position: String
                let photo: URL
            }
        }
    }
            
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Player] {
        guard response.isOK else {
            throw MapperError.unsuccessfullyResponse
        }
        
        do {
            //print(String(data: data, encoding: .utf8) ?? "No Data")
            let root = try JSONDecoder().decode(Root.self, from: data)
            return root.squad
        } catch {
            print(error)
            throw error
        }
    }
}

public struct Player: Hashable, Identifiable {
    public let id: Int
    public let name: String
    public let age: Int
    public let number: Int
    public let position: String
    public let photoURL: URL
    
    public init(id: Int, name: String, age: Int, number: Int, position: String, photoURL: URL) {
        self.id = id
        self.name = name
        self.age = age
        self.number = number
        self.position = position
        self.photoURL = photoURL
    }
}

//"response": [{
//    "team":
//    {
//        "id": 33,
//        "name": "Manchester United",
//        "logo": "https://media.api-sports.io/football/teams/33.png"
//    },
//    "players":
//    [
//        {
//            "id": 20319,
//            "name": "N. Bishop",
//            "age": 22,
//            "number": 30,
//            "position": "Goalkeeper",
//            "photo": "https://media.api-sports.io/football/players/20319.png"
//        }]
//}]
