//
//  RepoScrollViewModel.swift
//  GitGraphQL
//
//  Created by Elex Lee on 4/10/19.
//  Copyright © 2019 Elex Lee. All rights reserved.
//

import Apollo
import Foundation

protocol RepoScrollViewModelDelegate: class {
    func repoFetchCompleted()
    func repoFetchFailed(with reason: String)
}

final class RepoScrollViewModel {
    private weak var delegate: RepoScrollViewModelDelegate?
    
    private var repos: [Repo] = []
    private var currentEndCursor: String?
    private var total = 0
    private var currentlyFetching = false
    private var initialFetch = false
    private var hasNextPage = true
    
    var query: SearchRepositoriesQuery?
    
    init(delegate: RepoScrollViewModelDelegate) {
        self.delegate = delegate
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return repos.count
    }
    
    var didFinishInitialFetch: Bool {
        return initialFetch
    }
    
    func finishInitialFetch() {
        initialFetch = true
    }
    
    func resetInitialFetch() {
        initialFetch = false
    }
    
    func repo(at index: Int) -> Repo {
        return repos[index]
    }
    
    func fetchRepos() {
        if currentlyFetching || !hasNextPage { return }

        currentlyFetching = true
        
        GraphQLClient.shared.repositories(with: currentEndCursor) { (result, error) in
            DispatchQueue.main.async {
                self.currentlyFetching = false
                self.total = result?.data?.search.repositoryCount ?? 0
                
                guard let edges = result?.data?.search.edges else { return }
                edges.forEach { edge in
                    guard let repository = edge?.node?.asRepository else { self.delegate?.repoFetchFailed(with: "Unable to unwrap repository"); return }

                    let repo = Repo(repo: repository)
                    self.repos.append(repo)
                }
                
                self.delegate?.repoFetchCompleted()
                
                self.hasNextPage = (result?.data?.search.pageInfo.hasNextPage)!
                self.currentEndCursor = result?.data?.search.pageInfo.endCursor
            }
        }
    }
}
