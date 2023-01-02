//
//  ListPopularVC.swift
//  tmdb-app
//
//  Created by Adie on 02/01/23.
//

import UIKit
import RxSwift
class ListPopularVC: UIViewController {
    
    // MARK: Properties

    private let viewModel: ListPopularViewModel
    private let disposeBag = DisposeBag()
            
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(
            UINib(nibName: MovieCollectionViewCell.id, bundle: nil),
            forCellWithReuseIdentifier: MovieCollectionViewCell.id)
        collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "footer"
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    private let collectionViewFooter: UICollectionReusableView = {
        let view = UICollectionReusableView()
        return view
    }()
    
    let refreshControl = UIRefreshControl()
    
    var isAnimating: Binder<Bool> {
        return Binder(self) { [self] activityIndicator, active in
            if active {
                showLoading()
            } else {
                hideLoading()
            }
        }
    }
    
    // MARK: Initialization
    
    init(viewModel: ListPopularViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    
    private func setupUI(){
        
        self.title = "TMDB"
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        
    }
    
    private func bindViewModel(){
        
        refreshControl.rx.controlEvent([.valueChanged])
            .asObservable()
            .subscribe(onNext: { [unowned self] _ in
                refreshControl.beginRefreshing()
                viewModel.didRefresh()                
            })
            .disposed(by: disposeBag)
        
        viewModel.updateInfo
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.collectionView.reloadData()
                }
            }).disposed(by: disposeBag)
        
        viewModel.errorResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showAlertView(withTitle: "Error", andMessage: error.localizedDescription)
            }).disposed(by: disposeBag)

        viewModel.isLoading.bind(to: isAnimating).disposed(by: disposeBag)
        viewModel.isPaginationLoading.bind(to: isAnimating).disposed(by: disposeBag)

        viewModel.viewDidLoad()
    }

}
extension ListPopularVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let aspectRatio: CGFloat = 3 / 2
        let numberOfItemsInRow: CGFloat = 3

        let width: CGFloat = (UIScreen.main.bounds.width / numberOfItemsInRow)
        let height: CGFloat = width * aspectRatio

        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: "footer",
                for: indexPath
            )
            collectionViewFooter.frame = CGRect(x: 0, y: 0, width: footer.frame.size.width, height: 100)
            footer.addSubview(collectionViewFooter)
            return footer
        default:
            return UICollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.init(width: view.frame.size.width, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.id, for: indexPath) as? MovieCollectionViewCell
        else { return UICollectionViewCell() }

        let movie = viewModel.getMovie(at: indexPath)
        
        cell.bind(data: movie)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.getMovie(at: indexPath)
        viewModel.didSelectMovie(data: movie)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastSection = collectionView.numberOfSections - 1
        let lastItem = collectionView.numberOfItems(inSection: lastSection) - 1
        if indexPath.section == lastSection && indexPath.row == lastItem {
            viewModel.loadMoreData()
        }
    }
}
extension ListPopularVC{
    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            self.removeSpinner(on: self.view)
            self.removeSpinner(on: self.collectionViewFooter)
        }
    }

    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.viewModel.isLoadMore{
                self.showSpinner(on: self.collectionViewFooter, size: .medium)
            }else{
                self.showSpinner(on: self.view)
            }
            
        }
    }
}
