//
//  DescriptionViewController.swift
//  TEDBrowser
//
//  Created by Никита Плахин on 9/18/20.
//  Copyright © 2020 Никита Плахин. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    private var currentConstraints = [NSLayoutConstraint]()
    private var imageView: UIImageView = UIImageView()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 3
        return label
    }()
    
    private var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .lightGray
        return label
    }()
    
    private var buttonStack: UIStackView!
    private var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart")!.withTintColor(.lightGray, renderingMode: .alwaysTemplate), for: .normal)
        button.tintColor = .lightGray
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up")!.withTintColor(.lightGray, renderingMode: .alwaysTemplate), for: .normal)
        button.tintColor = .lightGray
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Информация"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .lightGray
        label.sizeToFit()
        let bottomRedLine = CALayer()
        bottomRedLine.frame = CGRect(x: 0, y: label.frame.size.height - 2, width: label.frame.width, height: 2)
        bottomRedLine.backgroundColor = UIColor.systemRed.cgColor
        label.layer.addSublayer(bottomRedLine)
        return label
    }()
    
    private var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textView.textColor = .lightGray
        textView.backgroundColor = .black
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    private var infoStack: UIStackView!
    private var containerStack: UIStackView!
    
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
        
        // setup button stack view
        self.buttonStack = UIStackView(arrangedSubviews: [self.likeButton, self.shareButton])
        self.buttonStack.axis = .horizontal
        self.buttonStack.distribution = .fillEqually
        self.buttonStack.alignment = .leading
        self.buttonStack.spacing = 20
        
        // info stack setup
        self.infoStack = UIStackView(arrangedSubviews: [self.titleLabel, self.authorLabel, self.buttonStack, self.infoLabel, self.descriptionTextView])
        self.infoStack.axis = .vertical
        self.infoStack.distribution = .fill
        self.infoStack.alignment = .leading
        self.infoStack.setCustomSpacing(40, after: self.authorLabel)
        self.infoStack.setCustomSpacing(20, after: self.buttonStack)
        
        // setup container stack view
        self.containerStack = UIStackView(arrangedSubviews: [self.imageView, self.infoStack])
        self.containerStack.axis = .vertical
        self.containerStack.distribution = .fillProportionally
        self.containerStack.alignment = .center
        self.containerStack.spacing = 10
        
        self.containerStack.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.containerStack)
        currentConstraints = [
            // thumbnail image
            NSLayoutConstraint(item: self.imageView, attribute: .width, relatedBy: .equal, toItem: self.containerStack, attribute: .width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.imageView, attribute: .height, relatedBy: .equal, toItem: self.containerStack, attribute: .width, multiplier: 9/16, constant: 0),
            
            // button size
            NSLayoutConstraint(item: self.likeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 30),
            NSLayoutConstraint(item: self.likeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30),
            NSLayoutConstraint(item: self.shareButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 30),
            NSLayoutConstraint(item: self.shareButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30),
            
            // info stack
            NSLayoutConstraint(item: self.descriptionTextView, attribute: .leading, relatedBy: .equal, toItem: self.containerStack, attribute: .leading, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: self.descriptionTextView, attribute: .trailing, relatedBy: .equal, toItem: self.containerStack, attribute: .trailing, multiplier: 1, constant: -10),
            
            // container stack view
            NSLayoutConstraint(item: self.containerStack!, attribute: .leading, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.containerStack!, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.containerStack!, attribute: .trailing, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.containerStack!, attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0),
        ]
        NSLayoutConstraint.activate(currentConstraints)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        if UIDevice.current.orientation.isPortrait {
            containerStack.addArrangedSubview(self.infoStack)
            let constraints = Array(currentConstraints[0...7])
            NSLayoutConstraint.activate(constraints)
        } else {
            let constraints = Array(currentConstraints[0...7])
            NSLayoutConstraint.deactivate(constraints)
            self.infoStack.removeFromSuperview()
        }
    }
}
