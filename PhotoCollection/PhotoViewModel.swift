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
    func image(completion: (Result<UIImage?, Error>) -> Void)
}

final class PhotoViewModel: PhotoViewModelInterface {
    
    let title: String
    
    let imageURL: URL
    
    init(with title: String, imageURL: URL) {
        self.title = title
        self.imageURL = imageURL
    }
    
    func image(completion: (Result<UIImage?, Error>) -> Void) {
           
    }
}
