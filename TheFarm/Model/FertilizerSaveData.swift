//
//  FertilizerSaveData.swift
//  TheFarm
//
//  Created by Nandan on 05/03/24.
//

import Foundation

// MARK: - FertilizerSaveData
struct FertilizerSaveData: Codable {
    let status: Int
    let message: String
    let data: FertilizerData?
}

// MARK: - FertilizerData
struct FertilizerData: Codable {
    let userID: Int
    let landID: String
    let landPartID: [String]
    let fertilizerName: String?
    let date, time: String
    let person: String?
    let updatedAt, createdAt: String
    let id: Int

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case landID = "land_id"
        case landPartID = "land_part_id"
        case fertilizerName = "fertilizer_name"
        case date, time, person
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}
