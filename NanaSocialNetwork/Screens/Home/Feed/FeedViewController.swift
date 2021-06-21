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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
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
        
        // Configure Segmented Control
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor(.appThemeColor)], for: .normal)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor(.appThemeTextColor)], for: .selected)
        
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
        case .success, .reload:
            refreshControl.endRefreshing()
            tableView.reloadData()
        case .deleted:
            showToastMessage("You post is deleted successfully")
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
    
    @IBAction func didSwichSegment(_ sender: UISegmentedControl) {
        viewModel.updateFeedType(at: sender.selectedSegmentIndex)
    }
}

//MARK: - Dialog & Router
extension FeedViewController {
    func showError() {
        showErrorDialog(title: "Error", message: "Please try again later.")
    }
    
    func showDeleteConfirmationDialog(postId: String) {
        let okAction = UIAlertAction(title: "Delete", style: .destructive) { [unowned self] _ in
            self.viewModel.deletePost(id: postId)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete this post?", preferredStyle: .alert)
        alert.addAction(okAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
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
        cell.deleteTapped = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let postId = strongSelf.viewModel.getDoucmentId(at: indexPath.row) {
                strongSelf.showDeleteConfirmationDialog(postId: postId)
            }
        }
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
