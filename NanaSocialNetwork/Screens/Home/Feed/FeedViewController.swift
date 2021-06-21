//
//  FeedViewController.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/21/21.
//

import UIKit
import RxSwift

class FeedViewController: UIViewController {

    // IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    private let viewModel = FeedViewModel()
    private let refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        viewModel.fetchFeedList()
    }
    
    // Setup View
    func setupView() {
        // Configure Refresh Control
        refreshControl.tintColor = UIColor(.appHeaderTextColor)
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh(_:)), for: .valueChanged)
        
        // Configure TableView
        tableView.registerCell(FeedItemCell.self)
        tableView.addSubview(refreshControl)
    }
    
    // BindView Model
    func bindViewModel() {
        viewModel.state
            .subscribe { [weak self] state in
                self?.updateState(state)
            }
            .disposed(by: disposeBag)
    }
    
    // Update State
    func updateState(_ state: FeedViewModel.State) {
        switch state {
        case .loading:
            refreshControl.beginRefreshing()
        case .error:
            refreshControl.endRefreshing()
            showError()
        case .success:
            refreshControl.endRefreshing()
            tableView.reloadData()
        default:
            refreshControl.endRefreshing()
        }
    }
}

//MARK: - IBAction
extension FeedViewController {
    @objc func pullToRefresh(_ sender: AnyObject) {
        viewModel.fetchFeedList()
    }
    
    @IBAction func didPressAdd(_ sender: Any) {
    }
}

//MARK: - Dialog & Router
extension FeedViewController {
    func showError() {
        showErrorDialog(title: "Error", message: "Please try again later.")
    }
}

//MARK: - UITableView DataSource & Delegate
extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(FeedItemCell.self, at: indexPath)
        cell.fill(viewModel.feedItem(at: indexPath.row))
        return cell
    }
}

//MARK: - Storyboard
extension FeedViewController {
    static func storyboardInstance() -> FeedViewController {
        return UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "FeedViewController")
            as! FeedViewController
    }
}
