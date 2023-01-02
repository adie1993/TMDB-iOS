//
//  BaseService.swift
//  tmdb-app
//
//  Created by Adie on 02/01/23.
//

import RxSwift
import RxCocoa

protocol BaseServiceProtocol {
    func request<T: Decodable>(baseRequest: Resource<T>) -> Observable<T>
}

final class BaseService: BaseServiceProtocol {
    
    func request<T: Decodable>(baseRequest: Resource<T>) -> Observable<T> {
        return Observable.just(baseRequest.request.completeURL)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                
                var request = URLRequest(url: baseRequest.request.completeURL)
                request.allHTTPHeaderFields = baseRequest.request.header
                request.httpMethod = baseRequest.request.method.rawValue
                request.timeoutInterval = baseRequest.request.timeout

                if let body = baseRequest.request.body {
                    request.httpBody = try? JSONSerialization.data(withJSONObject: body)
                }
                
                return URLSession.shared.rx.response(request: request)
        }.map { response, data -> T in

            if 200 ..< 300 ~= response.statusCode {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                return result
            } else {
                throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
            }

        }.asObservable()
    }
}
