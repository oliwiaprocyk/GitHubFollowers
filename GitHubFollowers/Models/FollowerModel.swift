//
//  FollowerModel.swift
//  GitHubFollowers
//
//  Created by Oliwia Procyk on 16/04/2023.
//

import Foundation

struct FollowerModel: Codable, Hashable {
    var login: String
    var avatarUrl: String

    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}
