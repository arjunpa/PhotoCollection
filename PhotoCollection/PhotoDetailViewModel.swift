//
//  PhotoDetailViewModel.swift
//  PhotoCollection
//
//  Created by Arjun P A on 15/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

protocol PhotoDetailViewModelInterface {
    var detailImageURL: URL { get }
    var title: String { get }
    func image(with size: CGSize, completion: @escaping (Result<UIImage?, Error>) -> Void)
    func cancelImageDownload()
}

final class PhotoDetailViewModel: PhotoDetailViewModelInterface {
    
    let detailImageURL: URL
    
    let title: String
    
    let imageDownloader: ImageDownloader
    
    let photo: Photo
    
    private var currentDownloadTask: ImageDownloadCancellableTask?
    
    init(photo: Photo, imageDownloader: ImageDownloader = ImageDownloader.default) {
        self.photo = photo
        self.detailImageURL = photo.url
        self.title = photo.title
        self.imageDownloader = imageDownloader
    }
    
    func image(with size: CGSize, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        self.currentDownloadTask = self.imageDownloader.downloadImage(with: self.detailImageURL, size: size, completion: completion)
    }
    
    func cancelImageDownload() {
        self.currentDownloadTask?.cancel()
    }
}
