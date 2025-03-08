//
//  PlayerEndpoint.swift
//  LigasEcAPI
//
//  Created by José Briones on 26/2/25.
//

import Foundation

// "https://flashlive-sports.p.rapidapi.com/v1/teams/squad?sport_id=1&locale=en_INT&team_id=Wtn9Stg0")
//TODO: Add tests
public enum PlayerEndpoint {
    case get(sportId: Int, locale: String, teamId: String)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(sportId, locale, teamId):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/teams" + "/squad"
            components.queryItems = [
                URLQueryItem(name: "sport_id", value: "\(sportId)"),
                URLQueryItem(name: "locale", value: "\(locale)"),
                URLQueryItem(name: "team_id", value: "\(teamId)")
            ].compactMap { $0 }
            return components.url!
        }
    }
}
