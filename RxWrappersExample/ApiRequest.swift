//
//  ApiRequest.swift
//  RxWrappersExample
//
//  Created by Sourav Chandra on 12/07/18.
//  Copyright © 2018 Sourav Chandra. All rights reserved.
//

import Foundation
import RxSwift

protocol ApiRequestType {
    func request() -> URLRequest
}

enum ApiRequest {
    case updateProfile(profileData: [String: Any])
    
    func makeRequest(_ completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        switch self {
        case .updateProfile:
            URLSession(configuration: .default).dataTask(with: request(), completionHandler: completion)
        }
    }
}

extension ApiRequest: ApiRequestType {
    func request() -> URLRequest {
        switch self {
        case let .updateProfile(profileData):
            let profileURL = URL(string: "http://localhost:8000/api/v1/profile")!
            let data = try? JSONSerialization.data(withJSONObject: profileData, options: .prettyPrinted)
            
            var request = URLRequest(url: profileURL)
            request.httpMethod = "POST"
            request.httpBody = data!
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            return request
        }
    }
}

extension ApiRequest: ReactiveCompatible {}

extension Reactive where Base: ApiRequestType {
    func makeRequest() -> Observable<Any> {
        return URLSession(configuration: .default).rx.json(request: base.request())
    }
}
