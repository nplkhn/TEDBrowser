//
//  TEDVideoTableViewCell.swift
//  TEDBrowser
//
//  Created by Никита Плахин on 8/27/20.
//  Copyright © 2020 Никита Плахин. All rights reserved.
//

import UIKit

class TEDVideoTableViewCell: UITableViewCell {
    @IBOutlet private weak var thumbnailImage: UIImageView!
    @IBOutlet private weak var authorName: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var videoTitle: UILabel!
    
    public var title: String = "" {
        didSet {
            videoTitle.text = title
        }
    }
    
    public var author: String = "" {
        didSet {
            authorName.text = author
        }
    }
    
    public var duration: String = "" {
        didSet {
            durationLabel.text = duration
        }
    }
    
    public var thumbnail: UIImage? {
        didSet {
            thumbnailImage.image = thumbnail
            thumbnailImage.tintColor = .lightGray
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .black
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }
    
}
