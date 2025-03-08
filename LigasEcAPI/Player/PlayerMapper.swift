//
//  PlayerMapper.swift
//  LigasEcAPI
//
//  Created by José Briones on 26/2/25.
//

import Foundation

public final class PlayerMapper {
        
    // MARK: - Root
    private struct Root: Codable {
        let data: [Datum]
        
        var squad: [Player] {
            data.flatMap { group in
                group.items.compactMap { item in
                    Player(id: item.playerID,
                           name: item.playerName,
                           number: item.playerJerseyNumber ?? 0,
                           position: item.playerTypeID.rawValue,
                           photoURL: item.playerImagePath)
                }
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case data = "DATA"
        }
        
        struct Datum: Codable {
            let groupID: Int
            let groupLabel: String
            let items: [Item]

            enum CodingKeys: String, CodingKey {
                case groupID = "GROUP_ID"
                case groupLabel = "GROUP_LABEL"
                case items = "ITEMS"
            }
            
            struct Item: Codable {
                let playerID, playerName: String
                let playerTypeID: PlayerTypeID
                let playerJerseyNumber: Int?
                let playerFlagID: Int
                let playerImagePath: URL?

                enum CodingKeys: String, CodingKey {
                    case playerID = "PLAYER_ID"
                    case playerName = "PLAYER_NAME"
                    case playerTypeID = "PLAYER_TYPE_ID"
                    case playerJerseyNumber = "PLAYER_JERSEY_NUMBER"
                    case playerFlagID = "PLAYER_FLAG_ID"
                    case playerImagePath = "PLAYER_IMAGE_PATH"
                }
            }
            
            enum PlayerTypeID: String, Codable {
                case coach = "COACH"
                case defender = "DEFENDER"
                case forward = "FORWARD"
                case goalkeeper = "GOALKEEPER"
                case midfielder = "MIDFIELDER"
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
            throw error
        }
    }
}

public struct Player: Hashable, Identifiable {
    public let id: String
    public let name: String
    public let number: Int
    public let position: String
    public let photoURL: URL?
    
    public init(id: String, name: String, number: Int, position: String, photoURL: URL?) {
        self.id = id
        self.name = name
        self.number = number
        self.position = position
        self.photoURL = photoURL
    }
}
