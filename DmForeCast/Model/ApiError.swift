//
//  ApiError.swift
//  DmForeCast
//
//  Created by Walter yun on 2021/06/02.
//

import Foundation

enum ApiError: Error {
    case unknown
    case invalidUrl(String)
    case invalidResponse
    case failed(Int)
    case emptyData
}
