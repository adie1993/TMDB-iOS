//
//  ListPopularViewModel.swift
//  tmdb-app
//
//  Created by Adie on 02/01/23.
//

import Foundation
import RxCocoa
import RxSwift

protocol ListPopularViewModelDataSource: BaseViewModelDataSource {
    var numberOfItems: Int { get }
    func getMovie(at indexPath: IndexPath) -> Movie
    var isPaginationLoading : Observable<Bool> { get }
}

final class ListPopularViewModel: ListPopularViewModelDataSource {
    
    
    var numberOfItems: Int { movieList.count }

    let updateInfo: Observable<Bool>
    let errorResult: Observable<Error>
    let isLoading: Observable<Bool>
    let isPaginationLoading: Observable<Bool>
    private let coordinator: ListPopularCoordinatorDelegate
    
    private let disposeBag = DisposeBag()
    private var movieList = [Movie]()
    private var currentPage: Int = 1
    private let popularNetworkHandler: PopularMoviesServiceProtocol
    var isLoadMore = false

    private let updateInfoSubject = PublishSubject<Bool>()
    private let errorResultSubject = PublishSubject<Error>()
    private let loadingSubject = BehaviorSubject<Bool>(value: true)
    private let paginationLoadingSubject = BehaviorSubject<Bool>(value: false)

    init(coordinator:ListPopularCoordinatorDelegate, networkHandling: PopularMoviesServiceProtocol = PopularMoviesService()) {
        self.coordinator = coordinator
        popularNetworkHandler = networkHandling
        
        updateInfo = updateInfoSubject.asObservable()
        errorResult = errorResultSubject.asObservable()
        isLoading = loadingSubject.asObservable()
        isPaginationLoading = paginationLoadingSubject.asObservable()
    }

    func viewDidLoad() {
        loadingSubject.onNext(true)
        getPopularMovies()
    }
    
    func loadMoreData() {
        isLoadMore = true
        paginationLoadingSubject.onNext(true)
        getPopularMovies()
    }
    
    func didRefresh(){
        guard !isLoadMore else { return }
        currentPage = 1
        movieList = []
        updateInfoSubject.onNext(true)
        getPopularMovies()        
    }
    
    func didSelectMovie(data: Movie) {
        coordinator.navigateToDetail(data: data)
    }

    func getMovie(at indexPath: IndexPath) -> Movie { self.movieList[indexPath.row] }
        
    private func getPopularMovies() {
        popularNetworkHandler
            .getPopular(page: currentPage)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.movieList += result.results
                self.updateInfoSubject.onNext(true)
                self.currentPage = result.page + 1
                self.isLoadMore = false
                self.loadingSubject.onNext(false)
                self.paginationLoadingSubject.onNext(false)
                }, onError: { [weak self] error in
                    guard let self = self else { return }
                    self.errorResultSubject.on(.next(error))
                    self.isLoadMore = false
                    self.loadingSubject.onNext(false)
                    self.paginationLoadingSubject.onNext(false)
            })
            .disposed(by: disposeBag)
    }
}
