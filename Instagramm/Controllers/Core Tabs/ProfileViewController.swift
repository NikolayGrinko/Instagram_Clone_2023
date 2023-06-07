//
//  ProfileViewController.swift
//  Instagramm
//
//  Created by Николай Гринько on 27.05.2023.
//

import UIKit

final class ProfileViewController: UIViewController {

    private var collectionView: UICollectionView?
    
    private var userPost = [UserPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        let size = (view.width - 4) / 3
        layout.itemSize = CGSize(width: size, height: size)
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
                
        //Cell
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        //Headers
        collectionView?.register(ProfileInfoHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,  withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier)
        
        collectionView?.register(ProfileTabsCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,  withReuseIdentifier: ProfileTabsCollectionReusableView.identifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettingButton))
    }
    
   @objc private func didTapSettingButton() {
       let vc = SettingsViewController()
       vc.title = "Setting"
       navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
      //  return userPost.count
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       // let model = userPost[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier,
                                                      for: indexPath) as! PhotoCollectionViewCell
        //cell.configure(with: model)
        cell.configure(debug: "test")
        //cell.backgroundColor = .systemBlue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // get the model and post controller
        //let model = userPost[indexPath.row]
        
        let user = User(username: "Joe",
                        bio: "",
                        name: (first: "", last: ""),
                        profilePhoto: URL(string: "https://www.google.com")!,
                        birdthDate: Date(),
                        gender: .male,
                        count: UserCount(followers: 1, following: 1, posts: 1),
                        joinDate: Date())
        
        let post = UserPost(identifier: "",
                            postType: .photo,
                            thumbnailImage: URL(string: "https://google.com/")!,
                            postURL: URL(string: "https://google.com/")!,
                            caption: nil,
                            liceCount: [],
                            comments: [],
                            createdDate: Date(),
                            taggedUsers: [],
                            owner: user)
        
        let vc = PostViewController(model: post)
        vc.title = post.postType.rawValue
//        vc.title = "Post"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else  {
            // footer
            return UICollectionReusableView()
        }
        
        if indexPath.section == 1 {
            // tabs header
            
            let tabControlHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: ProfileTabsCollectionReusableView.identifier,
                                                                         for: indexPath) as! ProfileTabsCollectionReusableView
            tabControlHeader.delegate = self
            return tabControlHeader
            
        }
        
        let profileHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier,
                                                                     for: indexPath) as! ProfileInfoHeaderCollectionReusableView
        profileHeader.delegate = self
        return profileHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.width,
                          height: collectionView.height / 3)
        }
        // Size of section tabs
        return CGSize(width: collectionView.width,
                      height: 50)
    }
}

extension ProfileViewController: ProfileInfoHeaderCollectionReusableViewDelegate {
    
    func profileHeaderDidTapPostsButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        //scroll to the posts
        collectionView?.scrollToItem(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
    }
    
    func profileHeaderDidTaFollowersButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        
        var mocData = [UserRelationship]()
        for x in 0..<10 {
            mocData.append(UserRelationship(username: "@joe", name: "Joe Smith", type: x % 2 == 0 ? .following : .not_following))
        }
        
        let vc = ListViewController(data: mocData)
        vc.title = "Followers"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func profileHeaderDidTapFollowingButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        
        var mocData = [UserRelationship]()
        for x in 0..<10 {
            mocData.append(UserRelationship(username: "@joe", name: "Joe Smith", type: x % 2 == 0 ? .following : .not_following))
        }
        
        let vc = ListViewController(data: mocData)
        vc.title = "Following"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func profileHeaderDidTapEditProfileButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        present(UINavigationController(rootViewController: vc), animated: true)
    }
}

extension ProfileViewController: ProfileTabsCollectionReusableViewDelegate {
    func didTapTaggedButtonTap() {
        
    }
    
    func didTapGridButtonTap() {
        
    }
    
    
}
