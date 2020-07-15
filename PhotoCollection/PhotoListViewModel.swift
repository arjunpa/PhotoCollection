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
    func detailViewModel(at index: Int) -> PhotoDetailViewModelInterface
    func fetchPhotos()
    func cancelTasks(at index: Int)
}

protocol PhotoListViewDelegate: class {
    func updateView()
    func didFailWithError(error: DisplayableError)
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
    
    func detailViewModel(at index: Int) -> PhotoDetailViewModelInterface {
        return PhotoDetailViewModel(photo: self.photoViewModels[index].photo)
    }
    
    func fetchPhotos() {
        self.repository.fetchPhotos { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photoViewModels = photos.map({ PhotoViewModel(with: $0) })
                self?.viewDelegate?.updateView()
            case .failure:
                self?.viewDelegate?.didFailWithError(error: ServiceError.generic)
            }
        }
    }
    
    func cancelTasks(at index: Int) {
        self.item(at: index).cancelImageDownload()
    }
}
