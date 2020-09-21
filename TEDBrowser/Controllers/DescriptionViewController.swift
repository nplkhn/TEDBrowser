//
//  DescriptionViewController.swift
//  TEDBrowser
//
//  Created by Никита Плахин on 9/18/20.
//  Copyright © 2020 Никита Плахин. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    private var imageView: UIImageView = UIImageView()
    private var titleLabel: UILabel = UILabel()
    private var authorLabel: UILabel = UILabel()
    private var buttonStack: UIStackView!
    private var likeButton: UIButton = UIButton()
    private var shareButton: UIButton = UIButton()
    private var infoLabel: UILabel = UILabel()
    private var descriptionTextView: UITextView = UITextView()
    
    private var containerStack: UIStackView!
    private var horizontalScrollView: UIScrollView?
    
    var video: TEDVideo! {
        didSet {
            titleLabel.text = video.title
            authorLabel.text = video.author
            descriptionTextView.text = video.videoDescription
            imageView.image = VideoManager.cache.object(forKey: video.videoID! as NSString) ?? UIImage(systemName: "video")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        // setup self.view
        self.view.backgroundColor = .black
        
        
        // setup title label
        self.titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        self.titleLabel.textColor = .white
        self.titleLabel.numberOfLines = 3
        
        
        // setup author label
        self.authorLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        self.authorLabel.textColor = .lightGray
        
        
        
        // setup like button
        self.likeButton.setImage(UIImage(systemName: "heart")!.withTintColor(.lightGray, renderingMode: .alwaysTemplate), for: .normal)
        self.likeButton.sizeThatFits(CGSize(width: 40, height: 40))
        self.likeButton.contentMode = .scaleAspectFit
        self.likeButton.tintColor = .lightGray
        
        
        // setup share button
        self.shareButton.setImage(UIImage(systemName: "square.and.arrow.up")?.withTintColor(.lightGray, renderingMode: .alwaysTemplate), for: .normal)
        self.shareButton.contentMode = .scaleAspectFit
        self.shareButton.tintColor = .lightGray
        
        
        // setup button stack view
        self.buttonStack = UIStackView(arrangedSubviews: [self.likeButton, self.shareButton])
        self.buttonStack.axis = .horizontal
        self.buttonStack.distribution = .fill
        self.buttonStack.alignment = .leading
        self.buttonStack.spacing = 10
        
        
        // setup info label
        self.infoLabel.text = "Информация"
        self.infoLabel.textColor = .lightGray
        let bottomRedLine = CALayer()
        self.infoLabel.layer.addSublayer(bottomRedLine)
        bottomRedLine.frame = CGRect(x: 0, y: self.infoLabel.bounds.maxY - 3, width: self.infoLabel.bounds.width, height: 3)
        bottomRedLine.backgroundColor = UIColor.red.cgColor
        
        // setup description text view
        self.descriptionTextView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        self.descriptionTextView.textColor = .lightGray
        
        // setup container stack view
        self.containerStack = UIStackView(arrangedSubviews: [self.imageView, self.titleLabel, self.authorLabel, self.buttonStack, self.infoLabel, self.descriptionTextView])
        self.containerStack.axis = .vertical
        self.containerStack.distribution = .fill
        self.containerStack.alignment = .leading
        self.containerStack.spacing = 10
        self.containerStack.setCustomSpacing(40, after: self.authorLabel)
        self.containerStack.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.containerStack)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.imageView, attribute: .width, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.imageView, attribute: .height, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .width, multiplier: 9/16, constant: 0),
            
            
            NSLayoutConstraint(item: self.containerStack!, attribute: .leading, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.containerStack!, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.containerStack!, attribute: .trailing, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.containerStack!, attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0),
        ])
    }
}
