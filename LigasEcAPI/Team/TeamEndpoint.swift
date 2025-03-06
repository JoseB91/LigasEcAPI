//
//  TeamEndpoint.swift
//  LigasEcAPI
//
//  Created by José Briones on 25/2/25.
//

import Foundation

//https://flashlive-sports.p.rapidapi.com/v1/tournaments/standings?tournament_season_id=OEW8zvIT&standing_type=home&locale=en_INT&tournament_stage_id=OO37de6i'

//TODO: Add tests
public enum TeamEndpoint {
    case get(seasonId: String, standingType: String, locale: String, tournamentStageId: String)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(seasonId, standingType, locale, tournamentStageId):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/tournaments/standings"
            components.queryItems = [
                URLQueryItem(name: "tournament_season_id", value: "\(seasonId)"),
                URLQueryItem(name: "standing_type", value: "\(standingType)"),
                URLQueryItem(name: "locale", value: "\(locale)"),
                URLQueryItem(name: "tournament_stage_id", value: "\(tournamentStageId)")

            ].compactMap { $0 }
            return components.url!
        }
    }
}
