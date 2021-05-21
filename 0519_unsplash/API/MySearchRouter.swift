//
//  MySearchRouter.swift
//  0519_unsplash
//
//  Created by 손대홍 on 2021/05/21.
//

import Foundation
import Alamofire

// 검색 관련 api
enum MySearchRouter: URLRequestConvertible {
    
    case searchPhotos(term: String)
    case searchUsers(term: String)
    
    var baseURL: URL {
        return URL(string: API.BASE_URL + "search/")!
    }
    
    var method: HTTPMethod {
        // return .get
        switch self {
        case .searchPhotos, .searchUsers:
            return .get
        }
    }
    
    var endPoint: String {
        switch self {
        case .searchPhotos:
            return "photos/"
        case .searchUsers:
            return "users/"
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case let .searchPhotos(term), let .searchUsers(term):
            return ["query": term]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        // "https://api.unsplash.com/search/photos"
        // "https://api.unsplash.com/search/users"
        let url = baseURL.appendingPathComponent(endPoint)
        print("MySearchRouter - asURLRequest() url: \(url)")
        
        var request = URLRequest(url: url)
        request.method = method
        
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        
        //        switch self {
        //        case let .get(parameters):
        //            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        //        case let .post(parameters):
        //            request = try JSONParameterEncoder().encode(parameters, into: request)
        //        }
        
        return request
    }
}

