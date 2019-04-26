//
//  GraphQLHTTPNetworkTransport.swift
//  GitGraphQL
//
//  Created by Elex Lee on 4/13/19.
//  Copyright © 2019 Elex Lee. All rights reserved.
//

import Apollo
import Foundation

struct GraphQLHTTPStatusError: Error {
    var status: Int
}

class GraphQLHTTPNetworkTransport: NetworkTransport {
    
    enum HTTPMethod: String {
        case get    = "GET"
        case post   = "POST"
    }
    
    let url: URL
    let authToken: String?
    let session: URLSession
    let serializationFormat = JSONSerializationFormat.self
    
    init(url: URL, authToken: String? = nil, configuration: URLSessionConfiguration = .default) {
        self.url = url
        self.authToken = authToken
        self.session = URLSession(configuration: configuration)
    }
    
    func send<Operation>(operation: Operation, completionHandler: @escaping (GraphQLResponse<Operation>?, Error?) -> Void) -> Cancellable where Operation : GraphQLOperation {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = authToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let body = ["query": operation.queryDocument, "variables": operation.variables] as GraphQLMap
        request.httpBody = try! serializationFormat.serialize(value: body)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil { completionHandler(nil,error); return }
            guard let httpResponse = response as? HTTPURLResponse else { print("\(String(describing: response)) not an HTTPURLResponse"); return }
            
            if httpResponse.statusCode != 200 {
                print("Request failed with response: \(httpResponse)")
                completionHandler(nil, GraphQLHTTPStatusError(status: httpResponse.statusCode))
            } else {
                do {
                    guard let data = data else { return }
                    guard let body = try JSONSerialization.jsonObject(with: data, options: []) as? JSONObject else { return }
                    let response = GraphQLResponse(operation: operation, body: body)
                    completionHandler(response, nil)
                } catch {
                    print("JSONSerializationError:", error)
                }
            }
        }
        task.resume()
        return task
    }
}
