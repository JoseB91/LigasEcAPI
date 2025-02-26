//
//  TeamEndpoint.swift
//  LigasEcAPI
//
//  Created by José Briones on 25/2/25.
//

import Foundation
// https://v3.football.api-sports.io/teams?league=243&season=2023
//TODO: Add tests
public enum TeamEndpoint {
    case get(leagueId: Int, season: String)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(leagueId, season):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/teams"
            components.queryItems = [
                URLQueryItem(name: "league", value: "\(leagueId)"),
                URLQueryItem(name: "season", value: "\(season)")
            ].compactMap { $0 }
            return components.url!
        }
    }
}
