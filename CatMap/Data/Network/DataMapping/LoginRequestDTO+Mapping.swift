//
//  LoginRequestDTO+Mapping.swift
//  CatMap
//
//  Created by yun on 2023/09/07.
//

import Foundation

struct LoginRequestDTO: Encodable {
    let identityToken: String
    let authorizationCode: String
}
