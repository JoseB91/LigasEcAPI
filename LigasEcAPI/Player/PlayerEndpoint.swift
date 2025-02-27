//
//  PlayerEndpoint.swift
//  LigasEcAPI
//
//  Created by José Briones on 26/2/25.
//

import Foundation

//TODO: Add tests
public enum PlayerEndpoint {
    case get(teamId: Int)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(teamId):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/players" + "/squads"
            components.queryItems = [
                URLQueryItem(name: "team", value: "\(teamId)")
            ].compactMap { $0 }
            return components.url!
        }
    }
}
