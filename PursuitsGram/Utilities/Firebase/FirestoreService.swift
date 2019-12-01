//
//  FirestoreService.swift
//  PursuitsGram
//
//  Created by Krystal Campbell on 11/25/19.
//  Copyright © 2019 Krystal Campbell. All rights reserved.
//

import Foundation
import FirebaseFirestore

fileprivate enum FireStoreCollections: String {
    case users
    case posts
    case comments
}

enum SortingCriteria: String {
    case fromNewestToOldest = "dataCreated"
    var shouldSortDescending: Bool {
        switch self {
        case .fromNewestToOldest:
            return true
        }
    }
}

class FirestoreService {
    static let manager = FirestoreService()
    private let db = Firestore.firestore()
    
    //Mark: - AppUsers
    func createAppUser(user: AppUser, completion: @escaping (Result<(), Error>)-> ()){
        var fields = user.fieldsDict
        fields["dateCreated"] = Date()
        
        db.collection(FireStoreCollections.users.rawValue).document(user.uid).setData(fields){(error) in
            if let error = error {
                completion(.failure(error))
                print(error)
            }
            completion(.success(()))
        }
    }
       
        func updateCurrentUser(userName: String? = nil, photoURL: URL? = nil, completion: @escaping (Result<(), Error>) -> ()){
            guard let userId = FirebaseAuthService.manager.currentUser?.uid else {
                //MARK: TODO - handle can't get current user
                return
            }
            var updateFields = [String:Any]()
            
            if let user = userName {
                updateFields["userName"] = user
            }
            
            if let photo = photoURL {
                updateFields["photoURL"] = photo.absoluteString
            }
            
           
            //PUT request
            db.collection(FireStoreCollections.users.rawValue).document(userId).updateData(updateFields) { (error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
                
            }
        }
        
        func getAllUsers(completion: @escaping (Result<[AppUser], Error>) -> ()) {
            db.collection(FireStoreCollections.users.rawValue).getDocuments { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let users = snapshot?.documents.compactMap({ (snapshot) -> AppUser? in
                        let userID = snapshot.documentID
                        let user = AppUser(from: snapshot.data(), id: userID)
                        return user
                    })
                    completion(.success(users ?? []))
                }
            }
        }
        
        //MARK: Posts
        func createPost(post: Post, completion: @escaping (Result<(), Error>) -> ()) {
            var fields = post.fieldsDict
            fields["dateCreated"] = Date()
            db.collection(FireStoreCollections.posts.rawValue).addDocument(data: fields) { (error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
        
        func getAllPosts(sortingCriteria: SortingCriteria? = nil, completion: @escaping (Result<[Post], Error>) -> ()) {
            let completionHandler: FIRQuerySnapshotBlock = {(snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let posts = snapshot?.documents.compactMap({ (snapshot) -> Post? in
                        let postID = snapshot.documentID
                        let post = Post(from: snapshot.data(), id: postID)
                        return post
                    })
                    completion(.success(posts ?? []))
                }
            }
            
            let collection = db.collection(FireStoreCollections.posts.rawValue)
            if let sortingCriteria = sortingCriteria {
                let query = collection.order(by:sortingCriteria.rawValue, descending: sortingCriteria.shouldSortDescending)
                query.getDocuments(completion: completionHandler)
            } else {
                collection.getDocuments(completion: completionHandler)
            }
        }
    
        
        func getPosts(forUserID: String, completion: @escaping (Result<[Post], Error>) -> ()) {
            db.collection(FireStoreCollections.posts.rawValue).whereField("creatorID", isEqualTo: forUserID).getDocuments { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let posts = snapshot?.documents.compactMap({ (snapshot) -> Post? in
                        let postID = snapshot.documentID
                        let post = Post(from: snapshot.data(), id: postID)
                        return post
                    })
                    completion(.success(posts ?? []))
                }
            }
            
        }
    
 
    func getUserFromPost(creatorID: String, completion: @escaping (Result<AppUser,Error>) -> ()) {
        db.collection(FireStoreCollections.users.rawValue).document(creatorID).getDocument { (snapshot, error) in
            
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot,
                let data = snapshot.data() {
                let userID = snapshot.documentID
                let user = AppUser(from: data, id: userID)
                if let appUser = user {
                    completion(.success(appUser))
                }
            }
        }
    }
    
     private init () {}
    
}
/*
  func updateAppUser(id: String,newDisplayName: String,completion: @escaping (Result<(),Error>) -> ()) {
        db.collection(FireStoreCollections.users.rawValue).document(id).updateData(["userName": newDisplayName]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
*/
