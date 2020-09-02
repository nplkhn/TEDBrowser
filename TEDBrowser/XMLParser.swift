//
//  File.swift
//  TEDBrowser
//
//  Created by Никита Плахин on 9/2/20.
//  Copyright © 2020 Никита Плахин. All rights reserved.
//

import Foundation

class FeedParser:NSObject {
    private var rssItems: [TEDVideoModel] = []
    private var currentElement = ""
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentAuthor: String = "" {
        didSet {
            currentAuthor = currentAuthor.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentDuration: String = "" {
        didSet {
            let index = currentDuration.firstIndex(of: ":") ?? currentDuration.startIndex
            currentDuration = String(currentDuration[index...])
        }
    }
    private var currentThumbnail: String = "" {
        didSet {
            currentThumbnail = currentThumbnail.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parserCompleteionHandler: (([TEDVideoModel]) -> Void)?
    
    
    func parseFeed(url: String, completetionHandler: (([TEDVideoModel]) -> Void)?) {
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
            currentTitle = ""
            currentAuthor = ""
            currentDuration = ""
            currentThumbnail = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title": currentTitle += string
        case "media:credit": currentAuthor += string
        case "itunes:duration": currentDuration += string
        case "itunes:image": currentThumbnail += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let video = TEDVideoModel(author: currentAuthor, title: currentTitle, duration: currentDuration, thumbnail: currentThumbnail)
            rssItems.append(video)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompleteionHandler?(rssItems)
        
    }
}