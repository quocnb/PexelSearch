//
//  Photo.swift
//  PexelSearch
//
//  Created by quocnb on 2021/10/27.
//

import Foundation

/*
 Pexel API Document: https://www.pexels.com/api/documentation/#
 */
class Photo: Codable {

    let id: Int
    let url: String
    let photographer: String
    let src: PhotoSource

    func thumbUrl() -> URL? {
        return URL(string: src.tiny)
    }
}

class PhotoSource: Codable {
    let original: String
    let tiny: String
}

class SearchResult: Codable {
    let nextPage: String?
    let photos: [Photo]

    init() {
        nextPage = ""
        photos = []
    }

    private enum CodingKeys : String, CodingKey {
        case photos, nextPage = "next_page"
    }
}
