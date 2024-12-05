//
//  RepoListView.swift
//  vpaginationListk
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 05.12.2024.
//

import Foundation
import SwiftUI

struct RepoListView: View {
    @StateObject private var viewModel = ReposViewModel()
    @State private var showEditModal = false
    @State private var selectedRepoIndex: Int?
    @State private var newDescription: String = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.repos) { repo in
                    RepoRow(repo: repo)
                        .padding(.vertical, 8)
                        .contextMenu {
                            Button(action: {
                                selectedRepoIndex = viewModel.repos.firstIndex(where: { $0.id == repo.id })
                                newDescription = repo.description ?? ""
                                showEditModal = true
                            }) {
                                Text("Edit")
                            }
                        }
                }
                .onDelete(perform: deleteRepo)
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.vertical, 16)
                }
            }
            .onAppear {
                viewModel.loadReposFromUserDefaults()
                Task {
                    await viewModel.loadRepos()
                }
            }
            .onChange(of: viewModel.repos.count) { _ in
                if viewModel.repos.count > 0 {
                    let threshold = 10
                    if viewModel.repos.count % threshold == 0 {
                        Task {
                            await viewModel.loadRepos()
                        }
                    }
                }
            }
            .navigationTitle("GitHub Repositories")
            .sheet(isPresented: $showEditModal) {
                EditRepoModal(
                    description: $newDescription,
                    onSave: {
                        if let selectedIndex = selectedRepoIndex {
                            viewModel.editRepo(at: selectedIndex, newDescription: newDescription)
                        }
                        showEditModal = false
                    }
                )
            }
        }
    }
    
    private func deleteRepo(at offsets: IndexSet) {
        viewModel.deleteRepo(at: offsets)
    }
}

struct RepoRow: View {
    var repo: Repo
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: repo.owner.avatar_url)) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
                    .frame(width: 40, height: 40)
            }
            
            VStack(alignment: .leading) {
                Text(repo.name)
                    .font(.headline)
                Text(repo.description ?? "No description")
                    .font(.subheadline)
                    .lineLimit(3)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct EditRepoModal: View {
    @Binding var description: String
    var onSave: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Description")) {
                    TextField("Description", text: $description)
                }
                
                Button("Save") {
                    onSave()
                }
            }
            .navigationTitle("Edit Repo")
        }
    }
}
