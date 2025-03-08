//
//  League.swift
//  LigasEcAPI
//
//  Created by José Briones on 23/2/25.
//

import Foundation

public struct League: Hashable, Identifiable {
    public let id: String // seasonId
    public let stageId: String
    public let name: String
    public let logoURL: URL
    
    public init(id: String, stageId: String, name: String, logoURL: URL) {
        self.id = id
        self.stageId = stageId
        self.name = name
        self.logoURL = logoURL
    }
}
