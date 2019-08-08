//
//  GIT.swift
//  SPMAndPod
//
//  Created by Ася on 08/08/2019.
//  Copyright © 2019 voidilov. All rights reserved.
//

import Foundation
import Moya

enum Git {
    
    enum API: TargetType {
        static let baseURL = URL(string: "https://api.github.com")!
        static let decoder: JSONDecoder = {
            let result = JSONDecoder()
            result.keyDecodingStrategy = .convertFromSnakeCase
            result.dateDecodingStrategy = .iso8601
            return result
        }()
        static let encoder: JSONEncoder = {
            let result = JSONEncoder()
            result.keyEncodingStrategy = .convertToSnakeCase
            result.dateEncodingStrategy = .iso8601
            return result
        }()
        static let provider = MoyaProvider<API>(plugins: [CredentialsPlugin { target -> URLCredential? in
            guard let api = target as? API else { return nil }
            switch api {
            case .auth(let login, let pass):
                return URLCredential(user: login, password: pass, persistence: .none)
            }
        }])
        
        case auth(login: String, pass: String)
        
        var baseURL: URL { return API.baseURL }
        var path: String { return "" }
        var method: Moya.Method { return .get }
        var sampleData: Data { return Data() }
        var task: Task {
            return .requestPlain
        }
        var headers: [String : String]? { return nil }
        
    }
    //WWW-Authenticate Basic
}
