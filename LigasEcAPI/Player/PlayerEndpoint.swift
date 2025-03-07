//
//  PlayerEndpoint.swift
//  LigasEcAPI
//
//  Created by José Briones on 26/2/25.
//

import Foundation

// "https://sportapi7.p.rapidapi.com/api/v1/team/%7Bid%7D/players")
//TODO: Add tests
public enum PlayerEndpoint {
    case get(teamId: Int)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(teamId):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/team/\(teamId)/players"
            return components.url!
        }
    }
}
