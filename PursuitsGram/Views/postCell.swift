//
//  postCell.swift
//  PursuitsGram
//
//  Created by Krystal Campbell on 11/26/19.
//  Copyright © 2019 Krystal Campbell. All rights reserved.
//

import UIKit

class postCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           setupConstraints()
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var postImages: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        return image
    }()
    
    private func setupConstraints() {
        
    contentView.addSubview(postImages)
        
    postImages.translatesAutoresizingMaskIntoConstraints = false
        postImages.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        postImages.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        postImages.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        postImages.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
       }
}
