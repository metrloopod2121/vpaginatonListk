//
//  Repo.swift
//  vpaginationListk
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 05.12.2024.
//

import Foundation

struct Repo: Identifiable, Codable {
    var id: Int
    var name: String
    var description: String?
    var owner: Owner
}

struct Owner: Codable {
    var login: String
    var avatar_url: String
}

struct GitHubAPIResponse: Codable {
    var items: [Repo]
}
