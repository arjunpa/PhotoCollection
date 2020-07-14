//
//  APIResponse.swift
//  PhotoCollection
//
//  Created by Arjun P A on 15/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

struct APIHTTPResponse<T> {
    let dataResult: T
    let httpResponse: HTTPURLResponse?
}
