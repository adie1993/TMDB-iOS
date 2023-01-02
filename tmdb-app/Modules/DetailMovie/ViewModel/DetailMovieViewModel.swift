//
//  DetailMovieViewModel.swift
//  tmdb-app
//
//  Created by Adie on 02/01/23.
//

import Foundation
import RxCocoa
import RxSwift

protocol DetailMovieViewModelDataSource: BaseViewModelDataSource {
    var numberOfItems: Int { get }
    func getReview(at indexPath: IndexPath) -> Reviews
}
final class DetailMovieViewModel: DetailMovieViewModelDataSource {
    
    
    var numberOfItems: Int { reviewList.count }    
    let updateInfo: Observable<Bool>
    let errorResult: Observable<Error>
    let isLoading: Observable<Bool>
    private var movie: Movie
    private var trailerList = [Trailer]()
    private var reviewList = [Reviews]()
    private let disposeBag = DisposeBag()
    
    private let networkHandler: DetailMovieServiceProtocol
    var isLoadMore = false

    private let updateInfoSubject = PublishSubject<Bool>()
    private let errorResultSubject = PublishSubject<Error>()
    private let loadingSubject = BehaviorSubject<Bool>(value: true)

    init(movie:Movie, networkHandling: DetailMovieServiceProtocol = DetailMovieService()) {
        self.movie = movie
        networkHandler = networkHandling
        
        updateInfo = updateInfoSubject.asObservable()
        errorResult = errorResultSubject.asObservable()
        isLoading = loadingSubject.asObservable()
    }

    func viewDidLoad() {
        
        getDetailMovie()
    }
        
    
    var backdropImageURL: String {
        guard let posterPath = movie.backdropPath else {
            return Constant.ImageURL.backdropPlaceholder
        }
        return Constant.ImageURL.highQuality + posterPath
    }

    var title: String {
        return movie.title
    }

    var primaryGenre: String {
        guard let primaryGenre = movie.genres?.first?.name else {
            return Constant.notAvailable
        }
        return primaryGenre
    }

    var subtitle: String {
        guard
            let runtime = movie.runtime, runtime > 0,
            let duration = convertMinutesToHoursAndMinutes(runtime: runtime),
            let releaseDate = movie.releaseDate,
            let releaseYear = getYearComponentOfDate(date: releaseDate)
        else {
            return Constant.notAvailable
        }

        return "\(primaryGenre) • \(releaseYear) • \(duration)"
    }

    var overview: String {
        return movie.overview
    }
    
    var youtubeId: String {
        let filtered = trailerList.filter({ $0.site.lowercased() == "youtube" && $0.name.lowercased().contains("official") })
        guard
            let data = filtered[safe: 0]
        else {
            return ""
        }
        return data.key
    }
    
    func getReview(at indexPath: IndexPath) -> Reviews { self.reviewList[indexPath.row] }    

    private func getDetailMovie() {
        loadingSubject.onNext(true)
        Observable.zip(networkHandler.getDetailMovie(id: movie.id), networkHandler.getTrailerMovie(id: movie.id), networkHandler.getReviewMovie(id: movie.id))
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.movie = result.0
                self.trailerList = result.1
                self.reviewList = result.2
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.errorResultSubject.on(.next(error))
                self.loadingSubject.onNext(false)
            }, onCompleted: {
                self.loadingSubject.onNext(false)
                self.updateInfoSubject.onNext(true)
            }).disposed(by: disposeBag)
    }
}

// MARK: Utility Extensions

extension DetailMovieViewModel {
    func convertMinutesToHoursAndMinutes(runtime: Int) -> String? {
        let dateComponentesFormatter = DateComponentsFormatter()
        dateComponentesFormatter.unitsStyle = .full
        dateComponentesFormatter.calendar?.locale = Locale(identifier: "en-US")
        dateComponentesFormatter.allowedUnits = [.hour, .minute]

        let hoursAndMinutes = dateComponentesFormatter.string(
            from: TimeInterval(runtime) * 60
        )

        return hoursAndMinutes
    }

    func getYearComponentOfDate(date: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: date) else {
            return nil
        }
        formatter.dateFormat = "yyyy"
        let yearOfRelease = formatter.string(from: date)

        return yearOfRelease
    }
}
