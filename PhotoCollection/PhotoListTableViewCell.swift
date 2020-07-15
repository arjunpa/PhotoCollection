//
//  PhotoListTableViewCell.swift
//  PhotoCollection
//
//  Created by Arjun P A on 15/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

class PhotoListTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    
    func configure(with viewModelInterface: PhotoViewModelInterface) {
        self.titleLabel.text = viewModelInterface.title
        self.thumbnailImageView.image = nil
        viewModelInterface.image { [weak self] result in
            switch result {
            case .success(let image):
                self?.thumbnailImageView.image = image
            case .failure:
                self?.thumbnailImageView.image = nil
            }
        }
    }
}
