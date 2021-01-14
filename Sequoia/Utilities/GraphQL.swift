//
//  GraphQL.swift
//  Sequoia
//
//  Created by Blair Mitchelmore on 2021-01-13.
//

import Foundation

enum QueryError: Error {
    case invalidURL
    case invalidHTTPBody
}

protocol GraphQL {
    func search<T: Codable>(query: String, completion: @escaping (Result<SearchPage<T>, Error>) -> Void)
}

private struct QueryData: Codable {
    var query: String
}

final class SimpleGraphQL: GraphQL {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let mainThread: MainThreadDispatch
    private let auth: String

    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder(), encoder: JSONEncoder = JSONEncoder(), mainThread: MainThreadDispatch = GCDMainThreadDispatch(), auth: String) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
        self.mainThread = mainThread
        self.auth = auth
    }
    
    func search<T: Codable>(query: String, completion: @escaping (Result<SearchPage<T>, Error>) -> Void) {
        let data: Data
        do {
            data = try encoder.encode(QueryData(query: query))
        } catch {
            mainThread.failure(error: QueryError.invalidHTTPBody, completion: completion)
            return
        }
        
        guard let url = URL(string: "https://api.github.com/graphql") else {
            mainThread.failure(error: QueryError.invalidURL, completion: completion)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.addValue("bearer \(auth)", forHTTPHeaderField: "Authorization")
        let task = session.dataTask(with: request) { [mainThread, decoder] (data, response, error) in
            if let error = error {
                mainThread.failure(error: error, completion: completion)
            } else if let data = data {
                do {
                    let parsed = try decoder.decode(SearchData<T>.self, from: data)
                    if let lastCursor = parsed.data.search.edges.last?.cursor {
                        let results = parsed.data.search.edges.map { $0.node }
                        let page = SearchPage(results: results, lastCursor: lastCursor)
                        mainThread.success(value: page, completion: completion)
                    } else {
                        let empty = SearchPage<T>(results: [], lastCursor: nil)
                        mainThread.success(value: empty, completion: completion)
                    }
                } catch {
                    mainThread.failure(error: error, completion: completion)
                }
            }
        }
        task.resume()
    }
}

private enum GraphQLSearchType: String, CustomStringConvertible {
    case repo = "REPOSITORY"
    
    var description: String {
        rawValue
    }
}

extension GraphQL {
    func queryRepos(search: String, after cursor: String? = nil, completion: @escaping (Result<SearchPage<RepoDetails>, Error>) -> Void) {
        // This is the simplest query sanitization on earth. First
        // todo is improve this maybe by using a custom string
        // interpolation to automatically escape things as needed
        var params: [(String,Any)] = [
            ("query", search),
            ("type", GraphQLSearchType.repo),
            ("first", 25),
        ]
        if let cursor = cursor {
            params.append(("after", cursor))
        }
        let stringified = params
            .map { (key, value) in
                let result: String
                if value is String {
                    let escaped = (value as! String).replacingOccurrences(of: "\"", with: #"\""#)
                    result = #"\#(key): "\#(escaped)""#
                } else {
                    result = "\(key): \(value)"
                }
                return result
            }
            .joined(separator: ", ")
        let query = """
      query listAll {
        search(\(stringified)) {
          edges {
            node {
              ... on Repository {
                id
                name
                url
                description
                owner {
                  avatarUrl
                  login
                }
                stargazerCount
              }
            }
            cursor
          }
        }
      }
"""
        self.search(query: query, completion: completion)
    }
}
