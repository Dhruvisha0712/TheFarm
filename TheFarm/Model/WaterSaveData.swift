//
//  SaveData.swift
//  TheFarm
//
//  Created by Nandan on 05/03/24.
//

import Foundation

// MARK: - WaterSaveData
struct WaterSaveData: Codable {
    let status: Int
    let message: String
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let userID: Int
    let landID: String
    let landPartID: [String]
    let date, time: String
    let person, volume, notes: String?
    let updatedAt, createdAt: String
    let id: Int

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case landID = "land_id"
        case landPartID = "land_part_id"
        case date, time, person, volume, notes
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}
