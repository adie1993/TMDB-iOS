//
//  DetailMovieService.swift
//  tmdb-app
//
//  Created by Adie on 02/01/23.
//

import RxSwift

protocol DetailMovieServiceProtocol {
    func getDetailMovie(id: Int) -> Observable<Movie>
    func getTrailerMovie(id: Int) -> Observable<[Trailer]>
    func getReviewMovie(id: Int) -> Observable<[Reviews]>
}

final class DetailMovieService: DetailMovieServiceProtocol {
    
    private let service: BaseServiceProtocol

    init(withService service: BaseServiceProtocol = BaseService()) {
        self.service = service
    }
    
    func getDetailMovie(id: Int) -> Observable<Movie> {
        let baseRequest: Resource<Movie> = { Resource(request: DetailMovieRequest.getMovie(id: id)) }()

        return self.service.request(baseRequest: baseRequest)
            .asObservable()
            .retry(2)
    }
    
    func getTrailerMovie(id: Int) -> Observable<[Trailer]> {
        let baseRequest: Resource<TrailerResponse> = { Resource(request: DetailMovieRequest.getTrailer(id: id)) }()

        return self.service.request(baseRequest: baseRequest)
            .map{
                $0.results
            }
            .asObservable()
            .retry(2)
    }
    
    func getReviewMovie(id: Int) -> Observable<[Reviews]> {
        let baseRequest: Resource<ReviewResponse> = { Resource(request: DetailMovieRequest.getReview(id: id)) }()

        return self.service.request(baseRequest: baseRequest)
            .map{
                $0.results
            }
            .asObservable()
            .retry(2)
    }
    
    
}
