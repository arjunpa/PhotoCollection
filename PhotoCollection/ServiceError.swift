//
//  ServiceError.swift
//  PhotoCollection
//
//  Created by Arjun P A on 15/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

protocol DisplayableError {
    var title: String { get }
    var body: String { get }
}

struct ServiceError: DisplayableError {
    let title: String
    let body: String
}

extension ServiceError {
    static let generic = ServiceError(title: "Error", body: "Something went wrong. Please try again.")
}
