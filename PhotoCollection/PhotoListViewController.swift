//
//  PhotoListViewController.swift
//  PhotoCollection
//
//  Created by Arjun P A on 14/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

final class PhotoListViewController: UIViewController {
    
    var photosListViewModel: PhotoListViewModelInterface?
    
    @IBOutlet private weak var listTableView: UITableView! {
        didSet {
            self.configureTableView()
            self.registerCells()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photosListViewModel?.fetchPhotos()
    }
    
    private func registerCells() {
        self.listTableView.register(UINib(nibName: PhotoListTableViewCell.nibName,
                                          bundle: nil),
                                    forCellReuseIdentifier: PhotoListTableViewCell.reuseIdentifier)
    }
    private func configureTableView() {
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        self.listTableView.estimatedRowHeight = 82.0
        self.listTableView.rowHeight = UITableView.automaticDimension
        self.listTableView.tableFooterView = UIView(frame: .zero)
    }
}

extension PhotoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photosListViewModel?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = self.photosListViewModel?.item(at: indexPath.row),
              let photoCell = self.listTableView.dequeueReusableCell(withIdentifier: PhotoListTableViewCell.reuseIdentifier,
                                                                     for: indexPath) as? PhotoListTableViewCell
              else { return UITableViewCell() }
        photoCell.configure(with: viewModel)
        return photoCell
    }
}

extension PhotoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailViewModel = self.photosListViewModel?.detailViewModel(at: indexPath.item) else { return }
        let detailViewController: PhotoDetailViewController = UIStoryboard.init(storyboardName: .main).instantiateViewController()
        detailViewController.detailViewModel = detailViewModel
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.photosListViewModel?.cancelTasks(at: indexPath.row)
    }
}

extension PhotoListViewController: PhotoListViewDelegate {
    
    func updateView() {
        self.listTableView.reloadData()
    }
    
    func didFailWithError(error: DisplayableError) {
        let alertViewController = UIAlertController(title: error.title, message: error.body, preferredStyle: .alert)
        self.present(alertViewController, animated: true, completion: nil)
    }
}

extension PhotoListViewController: StoryboardInstantiable {}
