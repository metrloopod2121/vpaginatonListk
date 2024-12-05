//
//  GitHubAPI.swift
//  vpaginationListk
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 05.12.2024.
//

import Foundation
import Alamofire

class GitHubAPI {
    private let baseURL = "https://api.github.com/search/repositories"
    
    func fetchRepos(page: Int) async throws -> [Repo] {
        let url = "\(baseURL)?q=swift&sort=stars&order=asc&page=\(page)&per_page=10"
        
        // Извлечение токена из переменных окружения
        let token = Secrets.token
        
        // Заголовки с токеном
        let headers: HTTPHeaders = [
            "Authorization": "token \(token)"
        ]
        
        // Запрос с использованием Alamofire
        let response = await AF.request(url, headers: headers)
            .validate(statusCode: 200..<300)
            .serializingDecodable(GitHubAPIResponse.self)
            .response
        
        // Проверка на ошибку в ответе
        guard let result = response.value else {
            throw response.error ?? NSError(domain: "API", code: 0, userInfo: nil)
        }
        
        // Возвращаем список репозиториев
        return result.items
    }
}
