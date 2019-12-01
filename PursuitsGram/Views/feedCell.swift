//
//  feedCell.swift
//  PursuitsGram
//
//  Created by Krystal Campbell on 11/30/19.
//  Copyright © 2019 Krystal Campbell. All rights reserved.
//

import UIKit

class feedCell: UICollectionViewCell {
    
    var feedPhotos: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .green
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    
    var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .lightGray
        image.image = UIImage(systemName: "person")
        image.tintColor = .white
        return image
    }()
    
    var userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .systemRed
        label.textAlignment = .left
        return label
    }()
    
    func addSubviews(){
        
        contentView.addSubview(feedPhotos)
        infoView.addSubview(profileImage)
        infoView.addSubview(userNameLabel)
        contentView.addSubview(infoView)
    }
    
    func setupConstraints() {
        
       
        feedPhotos.translatesAutoresizingMaskIntoConstraints = false
        feedPhotos.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        feedPhotos.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        feedPhotos.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        feedPhotos.widthAnchor.constraint(equalToConstant: feedPhotos.frame.width).isActive = true
        feedPhotos.heightAnchor.constraint(equalToConstant: contentView.frame.height - 100).isActive = true

        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.topAnchor.constraint(equalTo: infoView.topAnchor, constant: -20).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: infoView.leadingAnchor).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 70).isActive = true

          
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: -20).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10).isActive = true
        userNameLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor).isActive = true
        userNameLabel.heightAnchor.constraint(equalTo: infoView.heightAnchor).isActive = true
    
        
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.topAnchor.constraint(equalTo: feedPhotos.bottomAnchor).isActive = true
        infoView.leadingAnchor.constraint(equalTo: feedPhotos.leadingAnchor).isActive = true
        infoView.trailingAnchor.constraint(equalTo: feedPhotos.trailingAnchor).isActive = true
        infoView.heightAnchor.constraint(equalToConstant: 100).isActive = true 
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

