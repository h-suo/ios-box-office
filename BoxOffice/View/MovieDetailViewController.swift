//
//  MovieDetailViewController.swift
//  BoxOffice
//
//  Created by kyungmin on 2023/08/05.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    private let boxOfficeManager: BoxOfficeManager
    private let movieName: String
    private let movieCode: String
    private let movieDetailView = MovieDetailView()
    
    init(boxOfficeManager: BoxOfficeManager, movieName: String, movieCode: String) {
        self.movieName = movieName
        self.movieCode = movieCode
        self.boxOfficeManager = boxOfficeManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = movieDetailView
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieDetailView.startActivityIndicator()
        loadMovieInformationData()
    }
    
    private func setupNavigation() {
        self.navigationItem.title = boxOfficeManager.movieInformation?.movieTitle
    }
    
    @objc private func loadMovieInformationData() {
        boxOfficeManager.fetchMovie(movieCode) { result in
            if result == false {
                DispatchQueue.main.async {
                    let alert = UIAlertController.errorAlert(NameSpace.fail, NameSpace.loadDataFail, actionTitle: NameSpace.check, actionType: .default)
                    
                    self.present(alert, animated: false)
                }
                
                return
            }
            
            guard let movieInformation = self.boxOfficeManager.movieInformation else {
                return
            }
            
            DispatchQueue.main.async {
                self.movieDetailView.setupMovieInformationStackView(movieInformation: movieInformation)
            }
        }
        
        boxOfficeManager.fetchPosterImage(movieName) { result in
            if result == false {
                DispatchQueue.main.async {
                    let alert = UIAlertController.errorAlert(NameSpace.fail, NameSpace.loadDataFail, actionTitle: NameSpace.check, actionType: .default)
                    
                    self.movieDetailView.stopActivityIndicator()
                    self.present(alert, animated: false)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                self.movieDetailView.setupPosterImageView(image: self.boxOfficeManager.posterImage)
                self.movieDetailView.stopActivityIndicator()
            }
        }
    }
}

// MARK: Name Space
extension MovieDetailViewController {
    private enum NameSpace {
        static let fail = "실패"
        static let loadDataFail = "데이터 로드에 실패했습니다."
        static let check = "확인"
    }
}
