//
//  TEDVideo.swift
//  TEDBrowser
//
//  Created by Никита Плахин on 9/13/20.
//  Copyright © 2020 Никита Плахин. All rights reserved.
//

import Foundation


class TEDVideo {
    var title: String?
    var author: String?
    var duration: String?
    var thumbnailURL: String?
    var videoURL: String?
    var videoID: String?
    var videoDescription: String?
    var isFavourite: Bool = false
    
    init(title: String, author: String, duration: String, thumbnailURL: String, videoURL: String, videoID: String, videoDescription: String) {
        self.title = title
        self.author = author
        self.duration = duration
        self.thumbnailURL = thumbnailURL
        self.videoURL = videoURL
        self.videoID = videoID
        self.videoDescription = videoDescription
    }
}
