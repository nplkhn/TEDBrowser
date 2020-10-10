//
//  TEDVideo+CoreDataClass.swift
//  TEDBrowser
//
//  Created by Никита Плахин on 9/25/20.
//  Copyright © 2020 Никита Плахин. All rights reserved.
//
//

import Foundation
import CoreData


//protocol Favouritable {
//    var isFavourite: Bool? {get set}
//}

@objc(TEDVideo)
public class TEDVideo: NSManagedObject {
    
    static func ==(lhs: TEDVideo, rhs: TEDVideo) -> Bool {
        return (lhs.title == rhs.title && lhs.author == rhs.author)
    }
}


