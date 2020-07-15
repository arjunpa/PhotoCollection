//
//  PhotoListViewModel.swift
//  PhotoCollection
//
//  Created by Arjun P A on 15/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

protocol PhotoListViewModelInterface {
    var numberOfRows: Int { get }
    func item(at index: Int) -> PhotoViewModelInterface
    func fetchPhotos()
    func cancelTasks(at index: Int)
}

protocol PhotoListViewDelegate: class {
    func updateView()
    func didFailWithError()
}

final class PhotoListViewModel: PhotoListViewModelInterface {
    
    let repository: PhotoListRepositoryInterface
    weak var viewDelegate: PhotoListViewDelegate?
    
    var numberOfRows: Int {
        return self.photoViewModels.count
    }
    
    private var photoViewModels: [PhotoViewModel] = []
    
    init(with repository: PhotoListRepositoryInterface) {
        self.repository = repository
    }
    
    func item(at index: Int) -> PhotoViewModelInterface {
        return self.photoViewModels[index]
    }
    
    func fetchPhotos() {
        self.repository.fetchPhotos { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photoViewModels = photos.map({ PhotoViewModel(with: $0.title, imageURL: $0.thumbnailURL) })
                self?.viewDelegate?.updateView()
            case .failure:
                self?.viewDelegate?.didFailWithError()
            }
        }
    }
    
    func cancelTasks(at index: Int) {
        self.item(at: index).cancelImageDownload()
    }
}