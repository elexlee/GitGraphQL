//
//  RepoScrollVC.swift
//  GitGraphQL
//
//  Created by Elex Lee on 4/9/19.
//  Copyright © 2019 Elex Lee. All rights reserved.
//

import Apollo
import UIKit

class RepoScrollVC: UIViewController {
    
    var indicatorView: UIActivityIndicatorView!
    var tableView: UITableView!
    var viewModel: RepoScrollViewModel!
    var cellId = "RepoCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        viewModel = RepoScrollViewModel(delegate: self)
        
        self.view.backgroundColor = .black
        self.title = "Repositories"
        
        setupTableView()
        setupIndicatorView()
        
        viewModel.fetchRepos()
    }
    
    func setupTableView() {
        tableView = UITableView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height))
        tableView.backgroundColor = .clear
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "RepoScrollCell", bundle: nil), forCellReuseIdentifier: cellId)
        self.view.addSubview(tableView)
    }
    
    func setupIndicatorView() {
        indicatorView = UIActivityIndicatorView(style: .whiteLarge)
        indicatorView.startAnimating()
        indicatorView.center = self.view.center
        self.view.addSubview(indicatorView)
    }
}

extension RepoScrollVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RepoScrollCell
        let repo = viewModel.repo(at: indexPath.row)
        cell.setup(repo: repo)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.currentCount - 10 {
            viewModel.fetchRepos()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! RepoScrollCell
        print("IndexPath: \(indexPath) \n\(viewModel.repo(at: indexPath.row))")
        cell.bounce()
    }
}

extension RepoScrollVC: RepoScrollViewModelDelegate {
    func repoFetchCompleted() {
        if !viewModel.didFinishInitialFetch {
            viewModel.finishInitialFetch()
            indicatorView.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            return
        }
        tableView.reloadData()
    }
    
    func repoFetchFailed(with reason: String) {
        indicatorView.stopAnimating()
        let alert = UIAlertController(title: "Warning", message: reason, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
