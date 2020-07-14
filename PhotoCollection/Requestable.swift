//
//  Requestable.swift
//  PhotoCollection
//
//  Created by Arjun P A on 14/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

protocol Requestable {
    func asURLRequest() throws -> URLRequest
}
