//
//  LoginData.swift
//  TheFarm
//
//  Created by Nandan on 28/02/24.
//

import Foundation

// MARK: - LoginData
struct LoginData: Codable {
    let status: Int
    let error: String?
    let accessToken, tokenType: String?
    let userData: UserData?

    enum CodingKeys: String, CodingKey {
        case status, accessToken, error
        case tokenType = "token_type"
        case userData
    }
}

// MARK: - UserData
struct UserData: Codable {
    let id: Int
    let name, email: String
    let emailVerifiedAt, passwordResetToken, deviceToken: String?
    let createdAt, updatedAt: String
    let role: [String]
    let roles: [Role]

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case emailVerifiedAt = "email_verified_at"
        case passwordResetToken = "password_reset_token"
        case deviceToken = "device_token"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case role, roles
    }
}

// MARK: - Role
struct Role: Codable {
    let id: Int
    let name, guardName, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case guardName = "guard_name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"

    }
}
