//
//  ReposViewModel.swift
//  vpaginationListk
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 05.12.2024.
//

import Foundation

@MainActor
class ReposViewModel: ObservableObject {
    @Published var repos: [Repo] = []
    @Published var isLoading = false
    private var currentPage = 1
    private let api = GitHubAPI()
    
    private let userDefaultsKey = "storedRepos"
    
    func loadRepos() async {
        guard !isLoading else { return }
        isLoading = true
        
        do {
            let fetchedRepos = try await api.fetchRepos(page: currentPage)
            self.repos.append(contentsOf: fetchedRepos)
            
            // Сохранение данных в UserDefaults
            saveReposToUserDefaults(fetchedRepos)
            
            currentPage += 1
        } catch {
            print("Error fetching repos: \(error)")
        }
        
        isLoading = false
    }
    
    func deleteRepo(at indexSet: IndexSet) {
        repos.remove(atOffsets: indexSet)
        saveReposToUserDefaults(repos)
    }
    
    func editRepo(at index: Int, newDescription: String) {
        repos[index].description = newDescription
        saveReposToUserDefaults(repos)
    }
    
    private func saveReposToUserDefaults(_ repos: [Repo]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(repos) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    func loadReposFromUserDefaults() {
        if let savedRepos = UserDefaults.standard.data(forKey: userDefaultsKey) {
            let decoder = JSONDecoder()
            if let decodedRepos = try? decoder.decode([Repo].self, from: savedRepos) {
                self.repos = decodedRepos
            }
        }
    }
}
