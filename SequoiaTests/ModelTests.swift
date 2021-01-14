//
//  ModelTests.swift
//  SequoiaTests
//
//  Created by Blair Mitchelmore on 2021-01-13.
//

import XCTest
@testable import Sequoia

class ModelTests: XCTestCase {

    func testDecodingResponse() throws {
        let result = """
        {
          "data": {
            "search": {
              "edges": [
                {
                  "node": {
                    "id": "MDEwOlJlcG9zaXRvcnkzMDMzNzE3MA==",
                    "name": "graphql-ruby",
                    "url": "https://github.com/rmosolgo/graphql-ruby",
                    "description": "Ruby implementation of GraphQL ",
                    "owner": {
                      "avatarUrl": "https://avatars0.githubusercontent.com/u/2231765?u=f440b90427dd354e5e689683e36b5bf812c8791a&v=4",
                      "login": "rmosolgo"
                    },
                    "stargazerCount": 4565
                  },
                  "cursor": "Y3Vyc29yOjEy"
                },
                {
                  "node": {
                    "id": "MDEwOlJlcG9zaXRvcnk1MjYzMDYxNg==",
                    "name": "apollo-client",
                    "url": "https://github.com/apollographql/apollo-client",
                    "description": ":rocket: A fully-featured, production ready caching GraphQL client for every UI framework and GraphQL server",
                    "owner": {
                      "avatarUrl": "https://avatars0.githubusercontent.com/u/17189275?v=4",
                      "login": "apollographql"
                    },
                    "stargazerCount": 15389
                  },
                  "cursor": "Y3Vyc29yOjEz"
                },
                {
                  "node": {
                    "id": "MDEwOlJlcG9zaXRvcnkzODYwMjQ1Nw==",
                    "name": "graphql-java",
                    "url": "https://github.com/graphql-java/graphql-java",
                    "description": "GraphQL Java implementation",
                    "owner": {
                      "avatarUrl": "https://avatars3.githubusercontent.com/u/14289921?v=4",
                      "login": "graphql-java"
                    },
                    "stargazerCount": 4669
                  },
                  "cursor": "Y3Vyc29yOjE0"
                },
                {
                  "node": {
                    "id": "MDEwOlJlcG9zaXRvcnkzODYzMjQ2OA==",
                    "name": "graphql-dotnet",
                    "url": "https://github.com/graphql-dotnet/graphql-dotnet",
                    "description": "GraphQL for .NET",
                    "owner": {
                      "avatarUrl": "https://avatars0.githubusercontent.com/u/13958777?v=4",
                      "login": "graphql-dotnet"
                    },
                    "stargazerCount": 4560
                  },
                  "cursor": "Y3Vyc29yOjE1"
                },
                {
                  "node": {
                    "id": "MDEwOlJlcG9zaXRvcnk4MDAxNjE1OQ==",
                    "name": "graphql-playground",
                    "url": "https://github.com/graphql/graphql-playground",
                    "description": "🎮  GraphQL IDE for better development workflows (GraphQL Subscriptions, interactive docs & collaboration)",
                    "owner": {
                      "avatarUrl": "https://avatars0.githubusercontent.com/u/12972006?v=4",
                      "login": "graphql"
                    },
                    "stargazerCount": 6802
                  },
                  "cursor": "Y3Vyc29yOjE2"
                },
                {
                  "node": {
                    "id": "MDEwOlJlcG9zaXRvcnk0MzA1Njk1MQ==",
                    "name": "graphene",
                    "url": "https://github.com/graphql-python/graphene",
                    "description": "GraphQL framework for Python",
                    "owner": {
                      "avatarUrl": "https://avatars3.githubusercontent.com/u/15002022?v=4",
                      "login": "graphql-python"
                    },
                    "stargazerCount": 6265
                  },
                  "cursor": "Y3Vyc29yOjE3"
                },
                {
                  "node": {
                    "id": "MDEwOlJlcG9zaXRvcnk3MDc5MzE5NA==",
                    "name": "GraphQL",
                    "url": "https://github.com/GraphQLSwift/GraphQL",
                    "description": "The Swift GraphQL implementation for macOS and Linux",
                    "owner": {
                      "avatarUrl": "https://avatars3.githubusercontent.com/u/22902791?v=4",
                      "login": "GraphQLSwift"
                    },
                    "stargazerCount": 804
                  },
                  "cursor": "Y3Vyc29yOjE4"
                },
                {
                  "node": {
                    "id": "MDEwOlJlcG9zaXRvcnk5MzU2NTU4Mg==",
                    "name": "howtographql",
                    "url": "https://github.com/howtographql/howtographql",
                    "description": "The Fullstack Tutorial for GraphQL",
                    "owner": {
                      "avatarUrl": "https://avatars0.githubusercontent.com/u/29239447?v=4",
                      "login": "howtographql"
                    },
                    "stargazerCount": 7318
                  },
                  "cursor": "Y3Vyc29yOjE5"
                },
                {
                  "node": {
                    "id": "MDEwOlJlcG9zaXRvcnk0MDIxNDA3MA==",
                    "name": "express-graphql",
                    "url": "https://github.com/graphql/express-graphql",
                    "description": "Create a GraphQL HTTP server with Express.",
                    "owner": {
                      "avatarUrl": "https://avatars0.githubusercontent.com/u/12972006?v=4",
                      "login": "graphql"
                    },
                    "stargazerCount": 5705
                  },
                  "cursor": "Y3Vyc29yOjIw"
                },
                {
                  "node": {
                    "id": "MDEwOlJlcG9zaXRvcnk1NDQzMjE2OA==",
                    "name": "graphql-tools",
                    "url": "https://github.com/ardatan/graphql-tools",
                    "description": ":wrench: Build, mock, and stitch a GraphQL schema using the schema language",
                    "owner": {
                      "avatarUrl": "https://avatars3.githubusercontent.com/u/20847995?u=a59be88dc0142b64204f271c811bec609ea36439&v=4",
                      "login": "ardatan"
                    },
                    "stargazerCount": 3857
                  },
                  "cursor": "Y3Vyc29yOjIx"
                },
                {
                  "node": {
                    "id": "MDEwOlJlcG9zaXRvcnkxMTY4Mzc0ODM=",
                    "name": "type-graphql",
                    "url": "https://github.com/MichalLytek/type-graphql",
                    "description": "Create GraphQL schema and resolvers with TypeScript, using classes and decorators!",
                    "owner": {
                      "avatarUrl": "https://avatars2.githubusercontent.com/u/10618781?u=2800e54d15ad79a12b24829f5d84ad6ff26cb655&v=4",
                      "login": "MichalLytek"
                    },
                    "stargazerCount": 5755
                  },
                  "cursor": "Y3Vyc29yOjIy"
                }
              ]
            }
          }
        }
        """
        guard let data = result.data(using: .utf8) else {
            XCTFail("Data generation failed somehow!")
            return
        }
        
        let output = try JSONDecoder().decode(SearchData<RepoDetails>.self, from: data)
        let details = output.data.search.edges.map { $0.node }
        
        XCTAssertEqual(details.first?.name, "graphql-ruby")
        XCTAssertEqual(details.first?.url, "https://github.com/rmosolgo/graphql-ruby")
        XCTAssertEqual(details.last?.description, "Create GraphQL schema and resolvers with TypeScript, using classes and decorators!")
        XCTAssertEqual(details.last?.owner.avatar, "https://avatars2.githubusercontent.com/u/10618781?u=2800e54d15ad79a12b24829f5d84ad6ff26cb655&v=4")
    }

}
