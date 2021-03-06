//
//  PhotoViewModel.swift
//  PhotoCollection
//
//  Created by Arjun P A on 15/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

protocol PhotoViewModelInterface {
    var title: String { get }
    var imageURL: URL { get }
    func image(with size: CGSize, completion: @escaping (Result<UIImage?, Error>) -> Void)
    func cancelImageDownload()
}

final class PhotoViewModel: PhotoViewModelInterface {
    
    let title: String
    
    let imageURL: URL
    
    let photo: Photo
    
    private let imageDownloader: ImageDownloaderInterface
    
    private var currentImageTask: ImageDownloadCancellableTask?
    
    init(with photo: Photo,
         imageDownloader: ImageDownloaderInterface = ImageDownloader.default) {
        self.photo = photo
        self.title = photo.title
        self.imageURL = photo.thumbnailURL
        self.imageDownloader = imageDownloader
    }
    
    func image(with size: CGSize, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        self.currentImageTask =  self.imageDownloader.downloadImage(with: self.imageURL,
                                                                    size: size,
                                                                    completion: completion)
    }
    
    func cancelImageDownload() {
        self.currentImageTask?.cancel()
    }
}
