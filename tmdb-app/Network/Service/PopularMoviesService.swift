//
//  PopularMoviesProvider.swift
//  tmdb-app
//
//  Created by Adie on 02/01/23.
//

import RxSwift

protocol PopularMoviesServiceProtocol {
    func getPopular(page: Int) -> Observable<MoviesResponse>
}

final class PopularMoviesService: PopularMoviesServiceProtocol {
    
    private let service: BaseServiceProtocol

    init(withService service: BaseServiceProtocol = BaseService()) {
        self.service = service
    }
    
    func getPopular(page: Int) -> Observable<MoviesResponse> {
        let baseRequest: Resource<MoviesResponse> = { Resource(request: PopularMoviesRequest.getPopularMovies(page: page)) }()

        return self.service.request(baseRequest: baseRequest)
            .asObservable()
            .retry(2)
    }    
    
}
