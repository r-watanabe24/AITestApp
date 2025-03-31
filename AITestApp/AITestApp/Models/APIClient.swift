//
//  APIClient.swift
//  AITestApp
//
//  Created by L_0045_r.watanabe on 2025/03/25.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift

final class APIClient {

    static let shared = APIClient()

    private init() {}

    func request(
        method: HTTPMethod,
        url: String,
        parameters: [String: Any]? = nil
    ) -> Single<JSON> {

        return Single<JSON>.create { single in
            let request = AF.request(
                url,
                method: method,
                parameters: parameters,
                encoding: method == .get ? URLEncoding.default : JSONEncoding.default,
                headers: [.contentType("application/json")]
            )
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    single(.success(json))
                case .failure(let error):
                    single(.failure(error))
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }

    func get(_ url: String, parameters: [String: Any]? = nil) -> Single<JSON> {
        return request(method: .get, url: url, parameters: parameters)
    }

    func post(_ url: String, parameters: [String: Any]? = nil) -> Single<JSON> {
        return request(method: .post, url: url, parameters: parameters)
    }

    func put(_ url: String, parameters: [String: Any]? = nil) -> Single<JSON> {
        return request(method: .put, url: url, parameters: parameters)
    }

    func delete(_ url: String, parameters: [String: Any]? = nil) -> Single<JSON> {
        return request(method: .delete, url: url, parameters: parameters)
    }
}
