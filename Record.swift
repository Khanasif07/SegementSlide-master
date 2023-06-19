//
//  Record.swift
//  Example
//
//  Created by Asif Khan on 19/06/2023.
//  Copyright © 2023 Jiar. All rights reserved.
//

import Foundation

struct News: Codable {
    var record: [Record]
    let metadata: Metadata
}

// MARK: - Metadat
struct Metadata: Codable {
    let id: String
    let metadatPrivate: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case metadatPrivate = "private"
        case createdAt
    }
}

// MARK: - Record
struct Record: Codable {
    var isSelected: Bool? = false
    let title: String
    let postURL: String
    let publishedAt: Date
    let postImageURL: String
    let readTime, primaryTag, content: String
    var dateString: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: publishedAt)
    }

    enum CodingKeys: String, CodingKey {
        case title
        case postURL = "postUrl"
        case publishedAt
        case postImageURL = "postImageUrl"
        case readTime, primaryTag, content
        case isSelected
    }
}



