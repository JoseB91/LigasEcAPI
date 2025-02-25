//
//  LeagueMapper.swift
//  LigasEcAPI
//
//  Created by José Briones on 23/2/25.
//

import Foundation

public final class LeagueMapper {
    
    private struct Root: Decodable {
        let response: [Response]
        
        var leagues: [League] {
            response.compactMap { League(id: $0.league.id,
                                         name: $0.league.name,
                                         logoURL: $0.league.logo)
            }
        }
                            
        struct Response: Codable {
            let league: ResponseLeague
            let country: Country
           
            struct Country: Codable {
                let name, code: String
                let flag: String
            }
            
            struct ResponseLeague: Codable {
                let id: Int
                let name, type: String
                let logo: URL
            }
        }
    }
            
    public enum Error: Swift.Error {
        case invalidData
        case unsuccessfullyResponse
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [League] {
        guard response.isOK else {
            throw Error.unsuccessfullyResponse
        }
        
        do {
            print(String(data: data, encoding: .utf8) ?? "No Data")
            let root = try JSONDecoder().decode(Root.self, from: data)
            return root.leagues
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

public struct League: Hashable, Identifiable {
    public let id: Int
    public let name: String
    public let logoURL: URL
    
    public init(id: Int, name: String, logoURL: URL) {
        self.id = id
        self.name = name
        self.logoURL = logoURL
    }
}
