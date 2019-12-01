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
    
   lazy var feedLabel: UILabel = {
    let label = UILabel()
    let attributedTitle = NSMutableAttributedString(string: "Feed", attributes: [NSAttributedString.Key.font: UIFont(name: "Marker Felt", size: 44)!, NSAttributedString.Key.foregroundColor: UIColor.white])
    label.attributedText = attributedTitle
    label.textAlignment = .center
    label.textColor = .white
    label.backgroundColor = .blue
    return label
    }()
    
    lazy var feedCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    cv.backgroundColor = .init(white: 0.1, alpha: 1)
    cv.register(feedCell.self, forCellWithReuseIdentifier: "feedCell")
    cv.delegate = self
    cv.dataSource = self
    return cv
    }()
               
//MARK: - Lifecycle Methods
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupConstraints()
            getPosts()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPosts()
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


   private func setupConstraints() {
    
    view.addSubview(feedCollectionView)
    feedCollectionView.translatesAutoresizingMaskIntoConstraints = false
    feedCollectionView.topAnchor.constraint(equalTo: feedLabel.bottomAnchor, constant: 40).isActive = true
    feedCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    feedCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    feedCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true

    view.addSubview(feedLabel)
    feedLabel.translatesAutoresizingMaskIntoConstraints = false
    feedLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    feedLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    feedLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    feedLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
     
  }

    

  

}
//MARK: - Extensions

extension PostsFeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as? feedCell else {
            return UICollectionViewCell()
        }
        let post = posts[indexPath.row]
        DispatchQueue.main.async {
            if let photoURL = post.imagePhoto {
                FirebaseStorageService.manager.getImage(url: photoURL) { (result) in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let fbImage):
                       cell.feedPhotos.image = fbImage
                        print("")
                    }
                }
            
            }
        }
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postSelected = posts[indexPath.row]
        let detailVC = PhotosDetailViewController()
        //detailVC.post = postSelected
        self.navigationController?.pushViewController(detailVC, animated: true)
       // present(detailVC, animated: true, completion: nil)
    }

    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 10, height: 500)

       }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}





      

