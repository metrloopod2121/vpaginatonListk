//
//  UD.swift
//  vpaginationListk
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 05.12.2024.
//

import Foundation

class UserDefaultsManager {
    
    private let reposKey = "reposKey"
    
    // Сохранить данные в UserDefaults
    func saveRepos(repos: [Repo]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(repos) {
            UserDefaults.standard.set(encoded, forKey: reposKey)
        }
    }
    
    // Получить данные из UserDefaults
    func getRepos() -> [Repo]? {
        if let savedRepos = UserDefaults.standard.data(forKey: reposKey) {
            let decoder = JSONDecoder()
            if let loadedRepos = try? decoder.decode([Repo].self, from: savedRepos) {
                return loadedRepos
            }
        }
        return nil
    }
    
    // Удалить все данные
    func clearRepos() {
        UserDefaults.standard.removeObject(forKey: reposKey)
    }
    
    // Удалить репозиторий по id
    func removeRepo(id: Int) {
        var repos = getRepos() ?? []
        repos.removeAll { $0.id == id }
        saveRepos(repos: repos)
    }
    
    // Обновить репозиторий
    func updateRepo(updatedRepo: Repo) {
        var repos = getRepos() ?? []
        if let index = repos.firstIndex(where: { $0.id == updatedRepo.id }) {
            repos[index] = updatedRepo
            saveRepos(repos: repos)
        }
    }
}
