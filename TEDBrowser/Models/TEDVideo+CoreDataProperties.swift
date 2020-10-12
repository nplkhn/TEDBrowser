//
//  TEDVideo+CoreDataProperties.swift
//  TEDBrowser
//
//  Created by Никита Плахин on 10/12/20.
//  Copyright © 2020 Никита Плахин. All rights reserved.
//
//

import Foundation
import CoreData


extension TEDVideo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TEDVideo> {
        return NSFetchRequest<TEDVideo>(entityName: "TEDVideo")
    }

    @NSManaged public var author: String
    @NSManaged public var duration: String
    @NSManaged public var thumbnail: String
    @NSManaged public var title: String
    @NSManaged public var videoDescription: String
    @NSManaged public var link: String

}

extension TEDVideo : Identifiable {

}
