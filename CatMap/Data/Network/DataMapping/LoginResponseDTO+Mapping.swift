//
//  LoginResponseDTO+Mapping.swift
//  CatMap
//
//  Created by yun on 2023/09/02.
//

import Foundation

struct LoginResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case accessToken = "appleAccessToken"
        case refreshToken = "appleRefreshToken"
        case nickname
    }
    
    let refreshToken: String
    let accessToken: String
    let nickname: String
}

extension LoginResponseDTO {
    func toDomain() -> User {
        return .init(accessToken: accessToken, nickname: nickname, refreshToken: refreshToken)
    }
}
