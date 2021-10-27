//
//  Connector.swift
//  PexelSearch
//
//  Created by quocnb on 2021/10/27.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

class Connector {
    static func searchPhotos(keyword: String) -> Observable<SearchResult> {
        RxAlamofire.request(ApiUrl.searchPhotos(keyword)).responseJSON()
            .catch { err in
                return Observable.empty()
            }.map { response in
                guard let data = response.data else {
                    return SearchResult()
                }
                return try JSONDecoder().decode(SearchResult.self, from: data)
            }
    }
}

enum ApiUrl: URLRequestConvertible {
    static let BASE_URL = "https://api.pexels.com/v1"
    static let PEXEL_API_KEY = "563492ad6f917000010000016df13a6f527146baa1f6bd81fb8b93bd"

    case searchPhotos(String)

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        switch self {
        case .searchPhotos:
            return "/search"
        }
    }

    var headers: HTTPHeaders {
        return HTTPHeaders(["Authorization": ApiUrl.PEXEL_API_KEY])
    }
    var parameters: Parameters {
        switch self {
            case .searchPhotos(let keyword):
                return ["query": keyword]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = try ApiUrl.BASE_URL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = headers
        switch self {
            case .searchPhotos:
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        return urlRequest
    }

}