//
//  PhotoDetailViewController.swift
//  PhotoCollection
//
//  Created by Arjun P A on 15/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    var detailViewModel: PhotoDetailViewModelInterface?
    
    @IBOutlet private weak var detailImageView: UIImageView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    private func configure() {
        guard let detailViewModel = self.detailViewModel else { return }
        self.titleLabel.text = detailViewModel.title
        detailViewModel.image(with: self.detailImageView.bounds.size) { [weak self] result in
            switch result {
            case .success(let image):
                self?.detailImageView.image = image
            case .failure:
                self?.detailImageView.image = nil
            }
        }
    }
}

extension PhotoDetailViewController: StoryboardInstantiable {}
