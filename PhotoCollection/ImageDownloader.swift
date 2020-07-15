//
//  ImageDownloader.swift
//  PhotoCollection
//
//  Created by Arjun P A on 15/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation
import Kingfisher

final class ImageDownloader: ImageDownloaderInterface {
    
    typealias ImageDownloadTask = DownloadTask
    
    static let `default` = ImageDownloader()
    
    private let kfManager: KingfisherManager
    
    init(kfManager: KingfisherManager = .shared) {
        self.kfManager = kfManager
    }
    
    func downloadImage(with url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void) -> ImageDownloadCancellableTask? {
        self.kfManager.retrieveImage(with: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    completion(.success(result.image))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

extension DownloadTask: ImageDownloadCancellableTask {}
