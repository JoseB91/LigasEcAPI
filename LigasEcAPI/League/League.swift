//
//  League.swift
//  LigasEcAPI
//
//  Created by José Briones on 23/2/25.
//

import Foundation

public struct League: Hashable, Identifiable {
    public let id: Int
    public let seasonId: Int
    public let name: String
    public let logoURL: URL
    
    public init(id: Int, seasonId: Int, name: String, logoURL: URL) {
        self.id = id
        self.seasonId = seasonId
        self.name = name
        self.logoURL = logoURL
    }
}
