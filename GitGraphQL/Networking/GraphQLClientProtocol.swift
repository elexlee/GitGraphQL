//
//  GraphQLClientProtocol.swift
//  GitGraphQL
//
//  Created by Elex Lee on 4/11/19.
//  Copyright © 2019 Elex Lee. All rights reserved.
//

import Apollo
import Foundation

let gitBase = "https://api.github.com/graphql"
let gitToken = "9e1a049407d113ee98cf9e62f29ef5be43db7956"

protocol GraphQLClientProtocol {
    func reinitialize()
    func repositories(query: String?, count: Int?, with cursor: String?, completion: @escaping (GraphQLResult<SearchRepositoriesQuery.Data>?, Error?) -> ())
}

class GraphQLClient: GraphQLClientProtocol {
    static let shared = GraphQLClient(url: URL(string: gitBase)!)

    private let url: URL
    private let configuration: URLSessionConfiguration
    private var apolloClient: ApolloClient!
    private let defaultCachePolicy = CachePolicy.fetchIgnoringCacheData
    
    init(url: URL, configuration: URLSessionConfiguration = .default) {
        self.url = url
        self.configuration = configuration
        reinitialize()
    }
    
    func reinitialize() {
        let safeConfiguration = self.configuration.copy() as! URLSessionConfiguration
        self.apolloClient = ApolloClient(networkTransport: GraphQLHTTPNetworkTransport(url: url, authToken: gitToken, configuration: safeConfiguration))
    }
    
    func repositories(query: String? = "graphql", count: Int? = 20, with cursor: String? = nil, completion: @escaping (GraphQLResult<SearchRepositoriesQuery.Data>?, Error?) -> ()) {
        let searchRepositoryQuery = SearchRepositoriesQuery(query: query!, count: count!, cursor: cursor)
        apolloClient.fetch(query: searchRepositoryQuery, cachePolicy: defaultCachePolicy) { result, error in
            
            if let error = error { print("Error: \(error)"); return }
            completion(result, nil)
        }
    }
}
