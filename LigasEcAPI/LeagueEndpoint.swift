//
//  LeagueEndpoint.swift
//  LigasEcAPI
//
//  Created by José Briones on 24/2/25.
//

import Foundation

public enum LeagueEndpoint {
    case get(country: String, season: String)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(country, season):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/leagues"
            components.queryItems = [
                URLQueryItem(name: "country", value: "\(country)"),
                URLQueryItem(name: "season", value: "\(season)")
            ].compactMap { $0 }
            return components.url!
        }
    }
}
