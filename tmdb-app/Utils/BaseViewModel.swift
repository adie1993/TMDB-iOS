//
//  BaseViewModel.swift
//  tmdb-app
//
//  Created by Adie on 02/01/23.
//

import RxSwift

protocol BaseViewModelDataSource: AnyObject {
    var updateInfo: Observable<Bool> { get }
    var errorResult: Observable<Error> { get }
    var isLoading: Observable<Bool> { get }
    func viewDidLoad()
}

