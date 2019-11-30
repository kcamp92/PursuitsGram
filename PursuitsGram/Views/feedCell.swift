//
//  feedCell.swift
//  PursuitsGram
//
//  Created by Krystal Campbell on 11/30/19.
//  Copyright © 2019 Krystal Campbell. All rights reserved.
//

import UIKit

class feedCell: UICollectionViewCell {
    
}
/*
class FeedCell: UICollectionViewCell {
    
    var feedImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    
    var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(white: 0.3, alpha: 0.8)
        return view
    }()
    
    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .lightGray
        image.image = UIImage(systemName: "person")
        image.tintColor = .white
        return image
    }()
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .clear
        
        label.textAlignment = .left
        return label
    }()
    
    
    func setImageConstraints() {
        contentView.addSubview(feedImage)
        feedImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feedImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            feedImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            feedImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            feedImage.widthAnchor.constraint(equalToConstant: feedImage.frame.width),
            feedImage.heightAnchor.constraint(equalToConstant: contentView.frame.height - 100)])
    }

    func setProfileImageConstraints() {
        infoView.addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: infoView.topAnchor, constant: -20),
            profileImage.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70)])
    }
    
    func setNameConstraints() {
           infoView.addSubview(nameLabel)
           nameLabel.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: -20),
               nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10),
               nameLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor),
               nameLabel.heightAnchor.constraint(equalTo: infoView.heightAnchor)])
       }
       
    
    func setInfoViewConstraints(){
        contentView.addSubview(infoView)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: feedImage.bottomAnchor),
            infoView.leadingAnchor.constraint(equalTo: feedImage.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: feedImage.trailingAnchor),
            infoView.heightAnchor.constraint(equalToConstant: 100)])
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImageConstraints()
        setInfoViewConstraints()
        setProfileImageConstraints()
        setNameConstraints()
    }

    override func layoutSubviews() {
        profileImage.layer.cornerRadius = (profileImage.frame.size.width) / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 3.0
        profileImage.layer.borderColor = UIColor.white.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
*/
