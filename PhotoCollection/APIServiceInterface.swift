//
//  APIServiceInterface.swift
//  PhotoCollection
//
//  Created by Arjun P A on 14/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

protocol APIServiceInterface {
    func request<T: Decodable>(for request: Requestable, completion: @escaping (Result<T, Error>) -> Void)
    func dataRequest(for request: Requestable, completion: @escaping (Result<Data, Error>) -> Void)
}
