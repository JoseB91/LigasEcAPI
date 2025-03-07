//
//  TeamEndpoint.swift
//  LigasEcAPI
//
//  Created by José Briones on 25/2/25.
//

import Foundation

// https://sportapi7.p.rapidapi.com/api/v1/unique-tournament/240/season/71184/teams

//TODO: Add tests
public enum TeamEndpoint {
    case get(id: Int, seasonId: Int)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id, seasonId):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/unique-tournament/\(id)/season/\(seasonId)/teams"
            return components.url!
        }
    }
}
