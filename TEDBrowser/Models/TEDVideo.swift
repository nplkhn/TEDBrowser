//
//  TEDVideo.swift
//  TEDBrowser
//
//  Created by Никита Плахин on 9/13/20.
//  Copyright © 2020 Никита Плахин. All rights reserved.
//

import Foundation


class TEDVideo {
    var author: String
    var duration: String
    var thumbnailURL: String
    var title: String
    
    init(video: TEDVideoModel) {
        author = video.author!
        duration = video.duration!
        thumbnailURL = video.thumbnailURL!
        title = video.title!
    }
}
