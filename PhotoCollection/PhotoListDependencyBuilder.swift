//
//  PhotoListDependencyBuilder.swift
//  PhotoCollection
//
//  Created by Arjun P A on 15/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

final class PhotoListDependencyBuilder {
    
    static func build() -> PhotoListViewController {
        let viewController: PhotoListViewController = UIStoryboard(storyboardName: .main).instantiateViewController()
        let photosListViewModel = PhotoListViewModel(with: PhotoListRepository(apiService: APIService(),
                                                                               cache: DiskURLCache.default))
        photosListViewModel.viewDelegate = viewController
        viewController.photosListViewModel = photosListViewModel
        return viewController
    }
}
