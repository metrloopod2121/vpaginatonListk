//
//  vpaginationListkTests.swift
//  vpaginationListkTests
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 05.12.2024.
//

import XCTest
@testable import vpaginationListk
@MainActor
final class PaginationListTests: XCTestCase {
    
    var api: GitHubAPI!
    var userDefaultsManager: UserDefaultsManager!
    var viewModel: ReposViewModel!
    
    override func setUpWithError() throws {
        api = GitHubAPI()
        userDefaultsManager = UserDefaultsManager()
        viewModel = ReposViewModel()
    }
    
    override func tearDownWithError() throws {
        api = nil
        userDefaultsManager = nil
        viewModel = nil
    }
    
    // MARK: - API Tests
    
    func testFetchReposReturnsData() async throws {
        do {
            let repos = try await api.fetchRepos(page: 1)
            XCTAssertFalse(repos.isEmpty, "API fetchRepos should return data")
        } catch {
            XCTFail("API fetchRepos threw an error: \(error)")
        }
    }

    
    // MARK: - UserDefaultsManager Tests
    
    func testSaveAndLoadRepos() throws {
        let mockRepos = [
            Repo(id: 1, name: "Repo 1", description: "Description 1", owner: Owner(login: "log1", avatar_url: "url1")),
            Repo(id: 2, name: "Repo 2", description: "Description 2", owner: Owner(login: "log2", avatar_url: "url2"))
        ]
        
        userDefaultsManager.saveRepos(repos: mockRepos)
        let loadedRepos = userDefaultsManager.getRepos()
        
        XCTAssertEqual(mockRepos.count, loadedRepos?.count, "Loaded repos count should match saved repos count")
        XCTAssertEqual(mockRepos.first?.name, loadedRepos?.first?.name, "Loaded repo name should match saved repo name")
    }
    
    func testRemoveRepoById() throws {
        let mockRepos = [
            Repo(id: 1, name: "Repo 1", description: "Description 1", owner:  Owner(login: "log1", avatar_url: "url1")),
            Repo(id: 2, name: "Repo 2", description: "Description 2", owner:  Owner(login: "log1", avatar_url: "url1"))
        ]
        
        userDefaultsManager.saveRepos(repos: mockRepos)
        userDefaultsManager.removeRepo(id: 1)
        
        let updatedRepos = userDefaultsManager.getRepos()
        XCTAssertFalse(updatedRepos?.contains(where: { $0.id == 1 }) ?? true, "Repo with ID 1 should be removed")
    }
    
    func testUpdateRepo() throws {
        var mockRepos = [
            Repo(id: 1, name: "Repo 1", description: "Description 1", owner:  Owner(login: "log1", avatar_url: "url1"))
        ]
        
        userDefaultsManager.saveRepos(repos: mockRepos)
        mockRepos[0].description = "Updated Description"
        userDefaultsManager.updateRepo(updatedRepo: mockRepos[0])
        
        let updatedRepos = userDefaultsManager.getRepos()
        XCTAssertEqual(updatedRepos?.first?.description, "Updated Description", "Repo description should be updated")
    }
    
    // MARK: - ViewModel Tests
    
    func testLoadReposFromAPI() async throws {
        await viewModel.loadRepos()
        XCTAssertFalse(viewModel.repos.isEmpty, "ViewModel should load repos from API")
    }
    
    func testDeleteRepo() throws {
        viewModel.repos = [
            Repo(id: 1, name: "Repo 1", description: "Description 1", owner:  Owner(login: "log1", avatar_url: "url1")),
            Repo(id: 2, name: "Repo 2", description: "Description 2", owner:  Owner(login: "log1", avatar_url: "url1"))
        ]
        
        viewModel.deleteRepo(at: IndexSet(integer: 0))
        XCTAssertEqual(viewModel.repos.count, 1, "Repo should be deleted")
        XCTAssertEqual(viewModel.repos.first?.id, 2, "Remaining repo should have ID 2")
    }
    
    func testEditRepo() throws {
        viewModel.repos = [
            Repo(id: 1, name: "Repo 1", description: "Description 1", owner:  Owner(login: "log1", avatar_url: "url1"))
        ]
        
        viewModel.editRepo(at: 0, newDescription: "New Description")
        XCTAssertEqual(viewModel.repos.first?.description, "New Description", "Repo description should be updated")
    }
}
