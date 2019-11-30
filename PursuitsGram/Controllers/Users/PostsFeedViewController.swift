//
//  PostsFeedViewController.swift
//  PursuitsGram
//
//  Created by Krystal Campbell on 11/26/19.
//  Copyright © 2019 Krystal Campbell. All rights reserved.
//

import UIKit

private let cellIdentifier = "feedCell"

class PostsFeedViewController: UIViewController {
    
//MARK:- UI Objects
    
    var posts = [Post]() {
        didSet {
            feedCollectionView.reloadData()
        }
    }
    
   lazy var myFeedLabel: UILabel = {
    let label = UILabel()
    let attributedTitle = NSMutableAttributedString(string: "Feed", attributes: [NSAttributedString.Key.font: UIFont(name: "Marker Felt", size: 44)!, NSAttributedString.Key.foregroundColor: UIColor.white])
    label.attributedText = attributedTitle
    label.textAlignment = .center
    label.textColor = .white
    label.backgroundColor = .clear
    return label
    }()
    
    lazy var feedCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    cv.backgroundColor = .init(white: 0.1, alpha: 1)
    cv.register(feedCell.self, forCellWithReuseIdentifier: "feedCell")
    return cv
    }()
               
//MARK: - Lifecycle Methods
        
        override func viewDidLoad() {
            super.viewDidLoad()
         
        }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
        
      }
      
        
//MARK: -Private Methods
    
    private func getPosts(){
        FirestoreService.manager.getAllPosts(sortingCriteria: nil) { (result) in
            switch result {
            case .success(let fbPosts):
                DispatchQueue.main.async {
                    if self.posts.count != fbPosts.count {
                        self.posts = fbPosts
                    } else {return}
                }
                case .failure(let error):
                print(error)
            }
        }
    }
    
//MARK: -UI Constraints
//MARK: - Extensions
        

  

  

}
