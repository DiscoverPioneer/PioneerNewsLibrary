//
//  Story.swift
//  News
//
//  Created by Phil Scarfi on 9/3/16.
//  Copyright © 2016 Pioneer Mobile Applications. All rights reserved.
//

import Foundation

public struct Story {
    public let title: String
    public let shortDescription: String
    public let imageURL: NSURL
    public let link: NSURL
    public var htmlBody: String?
    
    public init(title: String, shortDescription: String = "", imageURL: NSURL, link: NSURL) {
        self.title = title
        self.shortDescription = shortDescription
        self.imageURL = imageURL
        self.link = link
    }
}
