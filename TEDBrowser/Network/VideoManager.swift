//
//  VideoManager1.swift
//  TEDBrowser
//
//  Created by Никита Плахин on 9/28/20.
//  Copyright © 2020 Никита Плахин. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class VideoManager {
    // Core data
    static var context: NSManagedObjectContext?

    static var entity: NSEntityDescription {
        NSEntityDescription.entity(forEntityName: "TEDVideo", in: context!)!
    }
    
    // Video data
    static var favouriteVideos = [TEDVideo]() {
        didSet {
            favouriteVideos = favouriteVideos.sorted { (lhs, rhs) -> Bool in
                lhs.title < rhs.title
            }
            favouriteVideosCompletionHandler?(favouriteVideos)
        }
    }
    static var allVideos = [TEDVideo]() {
        didSet {
            allVideosCompletionHandler?(allVideos)
        }
    }
    static let cache = NSCache<NSNumber, NSData>()
    
    // Completion handlers
    private static var allVideosCompletionHandler: (([TEDVideo]) -> Void)?
    private static var favouriteVideosCompletionHandler: (([TEDVideo]) -> Void)?
    
    // getting data
    static func fetchVideos(allVideosCompletionHandler: (([TEDVideo]) -> Void)?, favouriteVideosCompletionHandler: (([TEDVideo]) -> Void)?) {
        
        VideoManager.allVideosCompletionHandler = allVideosCompletionHandler
        VideoManager.favouriteVideosCompletionHandler = favouriteVideosCompletionHandler
        
        fetchAllVideos()
        fetchFavouriteVideos()
    }
    
    private static func fetchAllVideos() {
        let parser = FeedParser()
        
        parser.parseFeed(url: "https://www.ted.com/themes/rss/id") { (allVideos) in
            self.allVideos = allVideos
            
        }
    }
    
    private static func fetchFavouriteVideos() {
        let fetchRequest: NSFetchRequest<TEDVideo> = TEDVideo.fetchRequest()
        
        do {
            favouriteVideos = try ((context?.fetch(fetchRequest))!)
//            favouriteVideos = try (context?.fetch(fetchRequest)) ?? []
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // fetching thumbnail images
    static func fetchThumbnail(for video: TEDVideo, completionHandler: @escaping (UIImage) -> Void) {
        let task = URLSession.shared.dataTask(with: URL(string: video.thumbnail)!) { (imageData, _, error) in
            if let imageData = imageData {
                guard error == nil else {
                    return
                }
                if let image = UIImage(data: imageData) {
                    VideoManager.cache.setObject(imageData as NSData, forKey: video.title.hashValue as NSNumber)
                    completionHandler(image)
                } else {
                    completionHandler(UIImage(systemName: "video")!)
                }
            }
        }
        task.resume()
    }
    
    // Manage favourites
    static func isFavourite(video: TEDVideo) -> Bool {
        return favouriteVideos.contains(where: {$0 == video})
    }
    
    static func addToFavourites(video: TEDVideo) {
        favouriteVideos.append(video)
        context?.insert(video)
        do {
            try context?.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func removeFromFavourites(video: TEDVideo) {
        favouriteVideos.removeAll(where: { (videoElement) -> Bool in
            video == videoElement
        })
        context?.delete(video)
        do {
            try context?.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

