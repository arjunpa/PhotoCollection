//
//  ImageDownloaderInterface.swift
//  PhotoCollection
//
//  Created by Arjun P A on 15/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

protocol ImageDownloadCancellableTask {
    func cancel()
}

protocol ImageDownloaderInterface {
    func downloadImage(with url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void) -> ImageDownloadCancellableTask?
}
