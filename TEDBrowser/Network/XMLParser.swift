//
//  File.swift
//  TEDBrowser
//
//  Created by Никита Плахин on 9/2/20.
//  Copyright © 2020 Никита Плахин. All rights reserved.
//

import Foundation

class FeedParser:NSObject {
    private var rssItems: [TEDVideo] = []
    private var currentElement = ""
    
    private var currentAuthor: String = ""
    private var currentDuration: String = "" {
        didSet {
            currentDuration = currentDuration.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentThumbnail: String = "" {
        didSet {
            currentThumbnail = currentThumbnail.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespaces)
        }
    }
    private var currentLink: String = ""
    
    private var parserCompleteionHandler: (([TEDVideo]) -> Void)?
    
    
    func parseFeed(url: String, completetionHandler: (([TEDVideo]) -> Void)?) {
        self.parserCompleteionHandler = completetionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let dataTask = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                
                return
            }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            
            parser.parse()
        }
        
        dataTask.resume()
    }
    
}

// MARK: xml parser delegate

extension FeedParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            currentAuthor = ""
            currentDuration = ""
            currentThumbnail = ""
            currentTitle = ""
            currentDescription = ""
        } else if currentElement == "itunes:image" {
            currentThumbnail = attributeDict["url"] ?? ""
        } else if currentElement == "media:content" && attributeDict["bitrate"] == "600" {
            currentLink = attributeDict["url"] ?? ""
        }
            
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title": currentTitle += string
        case "media:credit":
            if string != "" {
                currentAuthor += string + ", "
            }
        case "itunes:duration": currentDuration += string
        case "description": currentDescription += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            
            var index  = currentDuration.index(currentDuration.endIndex, offsetBy: -5)
            currentDuration = String(currentDuration[index...])
            
            
            index = currentTitle.index(before: currentTitle.firstIndex(of: "|")!)
            currentTitle = String(currentTitle[..<index])
            
            currentAuthor = currentAuthor.trimmingCharacters(in: CharacterSet(charactersIn: ",").union(CharacterSet.whitespacesAndNewlines))
            
            let video = TEDVideo(entity: VideoManager.entity, insertInto: nil)
            video.author = currentAuthor
            video.duration = currentDuration
            video.title = currentTitle
            video.thumbnail = currentThumbnail
            video.videoDescription = currentDescription
            video.link = currentLink
            
            rssItems.append(video)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompleteionHandler?(rssItems)
    }
}
