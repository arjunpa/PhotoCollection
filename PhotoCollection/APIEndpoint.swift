//
//  APIEndpoint.swift
//  PhotoCollection
//
//  Created by Arjun P A on 15/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

enum APIEndpoint: String, URLFormable {
    case getPhotos = "https://jsonplaceholder.typicode.com/photos"
    
    func asURL() throws -> URL {
        try self.rawValue.asURL()
    }
}

