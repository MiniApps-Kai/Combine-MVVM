//
//  QiitaItem.swift
//  Combine+MVVM
//
//  Created by 渡邊魁優 on 2024/05/11.
//

import Foundation

struct QiitaItem: Decodable {
    let title: String
    let user: QiitaUser
}

struct QiitaUser: Decodable {
    let profileImageUrl: String

    enum CodingKeys: String, CodingKey {
        case profileImageUrl = "profile_image_url"
    }
}
