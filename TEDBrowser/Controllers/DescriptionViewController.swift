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
    
    private var video: TEDVideo! {
        didSet {
            titleLabel.text = video.title
            authorLabel.text = video.author
            descriptionTextView.text = video.videoDescription
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    init(video: TEDVideo) {
        super.init(nibName: nil, bundle: nil)
        self.video = video
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        
        // setup self.view
        self.view.backgroundColor = .black
        
        // setup title label
        self.titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        self.titleLabel.textColor = .white
        self.titleLabel.numberOfLines = 3
        
        // setup author label
        self.authorLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
        self.authorLabel.textColor = .lightGray
        
        // setup like button
        self.likeButton.imageView?.image = self.video.isFavourite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        
        // setup share button
        self.shareButton.imageView?.image = UIImage(systemName: "square.and.arrow.up")
        
        // setup button stack view
        self.buttonStack = UIStackView(arrangedSubviews: [self.likeButton, self.shareButton])
        self.buttonStack.axis = .horizontal
        self.buttonStack.distribution = .fill
        self.buttonStack.alignment = .leading
        self.buttonStack.spacing = 10
        
        
        // setup info label
        self.infoLabel.text = "Информация"
        let bottomRedLine = CALayer()
        bottomRedLine.frame = CGRect(x: 0, y: self.infoLabel.bounds.maxY - 3, width: self.infoLabel.bounds.width, height: 3)
        bottomRedLine.backgroundColor = UIColor.red.cgColor
        self.infoLabel.layer.addSublayer(bottomRedLine)
        
        // setup description text view
        self.descriptionTextView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        
        // setup container stack view
        self.containerStack = UIStackView(arrangedSubviews: [self.imageView, self.titleLabel, self.authorLabel, self.buttonStack, self.infoLabel, self.descriptionTextView])
        self.containerStack.axis = .vertical
        self.containerStack.distribution = .fill
        self.containerStack.alignment = .center
        self.containerStack.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.containerStack)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.containerStack!, attribute: .leading, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.containerStack!, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.containerStack!, attribute: .trailing, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.containerStack!, attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0),
        ])
    }
}
