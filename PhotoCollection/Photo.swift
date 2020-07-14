//
//  Photo.swift
//  PhotoCollection
//
//  Created by Arjun P A on 15/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case albumID
        case id
        case title
        case url
        case thumbnailURL = "thumbnailUrl"
    }
    
    let albumID: Int
    let id: Int
    let title: String
    let url: URL
    let thumbnailURL: URL
}
