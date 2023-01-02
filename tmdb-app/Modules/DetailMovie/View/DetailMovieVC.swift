//
//  DetailMovieVC.swift
//  tmdb-app
//
//  Created by Adie on 02/01/23.
//

import UIKit
import YoutubePlayerView
import RxSwift

class DetailMovieVC: UIViewController {
    
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    @IBOutlet weak var stackVw: UIStackView!
    @IBOutlet weak var tableVw: UITableView!
    @IBOutlet weak var sectionReview: UIStackView!
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    @IBOutlet weak var playerVw: YoutubePlayerView!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var overviewLbl: UILabel!
    @IBOutlet weak var subLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    // MARK: Properties

    private let viewModel: DetailMovieViewModel
    private let disposeBag = DisposeBag()
    
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

    init(viewModel: DetailMovieViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
    }
    
    
    private func setupUI() {
     
        let playGesture = UITapGestureRecognizer(target: self, action: #selector(playTapped))
        playGesture.numberOfTapsRequired = 1
        imgPlay.addGestureRecognizer(playGesture)
        imgPlay.isUserInteractionEnabled = true
        
        tableVw.register(UINib(nibName: ReviewCell.id, bundle: nil), forCellReuseIdentifier: ReviewCell.id)
        tableVw.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tableVw.estimatedRowHeight = UITableView.automaticDimension
        tableVw.rowHeight = UITableView.automaticDimension
        tableVw.separatorStyle = .none
        
    }
    
    private func bindViewModel(){
              
        viewModel.updateInfo
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.updateView()
                }
            }).disposed(by: disposeBag)
        
        viewModel.errorResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showActionAlert(message: error.localizedDescription) {
                    self.viewModel.viewDidLoad()
                }
            }).disposed(by: disposeBag)

        viewModel.isLoading.bind(to: isAnimating).disposed(by: disposeBag)

        viewModel.viewDidLoad()
    }
    
    private func updateView() {
        if let url = URL(string: viewModel.backdropImageURL) {
            imgVw.setDetailImage(url: url)
        }
        titleLbl.text = viewModel.title
        subLbl.text = viewModel.subtitle
        overviewLbl.text = viewModel.overview
        
        if !viewModel.youtubeId.isEmpty{
            imgPlay.isHidden = false
            setupVideo()
        }
        
        if viewModel.numberOfItems != 0{
            sectionReview.isHidden = false
            tableVw.reloadData()
        }
        
        stackVw.isHidden = false
    }
    
    private func setupVideo(){
        playerVw.delegate = self
        let playerVars: [String: Any] = [
            "controls": 1,
            "modestbranding": 0,
            "playsinline": 1,
            "rel": 0,
            "autoplay": 0,
            "origin": "https://youtube.com"
        ]
        playerVw.loadWithVideoId(viewModel.youtubeId, with: playerVars)
    }
    
    @objc func playTapped() {
        playerVw.isHidden = false
        imgVw.isHidden = true
        imgPlay.isHidden = true
        actIndicator.startAnimating()
        playerVw.play()
    }
    
    @IBAction func closeAct(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
extension DetailMovieVC : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.id) as? ReviewCell else { return UITableViewCell() }
        let review = viewModel.getReview(at: indexPath)
        cell.bind(data: review)
        return cell
    }

}
extension DetailMovieVC {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"{
            if object is UITableView{
                if let newValue = change?[.newKey]{
                    let newSize = newValue as! CGSize
                    self.heightTable.constant = newSize.height
                }
            }
        }
    }
}
extension DetailMovieVC : YoutubePlayerViewDelegate{
    
    func playerViewDidBecomeReady(_ playerView: YoutubePlayerView) {
        actIndicator.stopAnimating()
        actIndicator.isHidden = true
    }

    func playerViewPreferredBackgroundColor(_ playerView: YoutubePlayerView) -> UIColor {
        return .black
    }
    
}
extension DetailMovieVC{
    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.removeSpinner(on: self.view)
        }
    }

    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showSpinner(on: self.view)
        }
    }
}
