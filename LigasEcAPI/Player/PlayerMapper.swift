//
//  PlayerMapper.swift
//  LigasEcAPI
//
//  Created by José Briones on 26/2/25.
//

import Foundation

public final class PlayerMapper {
    // TODO: Pagination
    
    private struct Root: Codable {
        let players: [PlayerResponse]
        
        var squad: [Player] {
            players.compactMap { Player(id: $0.player.id,
                                        name: $0.player.name,
                                        number: $0.player.shirtNumber,
                                        position: $0.player.position)
            }
        }
            
        struct PlayerResponse: Codable {
            let player: PlayerCodable
            
            struct PlayerCodable: Codable {
                let name, slug: String
                let shortName, position: String
                let jerseyNumber: String?
                let height: Int?
                let userCount: Int
                let id: Int
                let shirtNumber: Int?
                let dateOfBirthTimestamp: Int
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
    public let number: Int?
    public let position: String
    public let photoURL: URL?
    
    public init(id: Int, name: String, number: Int?, position: String, photoURL: URL? = nil) {
        self.id = id
        self.name = name
        self.number = number
        self.position = position
        self.photoURL = photoURL
    }
}
