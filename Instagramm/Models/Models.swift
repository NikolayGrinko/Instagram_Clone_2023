//
//  Models.swift
//  Instagramm
//
//  Created by Николай Гринько on 01.06.2023.
//

import Foundation

enum Gender {
    case male, female, other
}

struct User {
    let username: String
    let bio: String
    let name: (first: String, last: String)
    let profilePhoto: URL
    let birdthDate: Date
    let gender: Gender
    let count: UserCount
    let joinDate: Date
}

struct UserCount {
    let followers: Int
    let following: Int
    let posts: Int
}

public enum UserPostType: String {
    case photo = "Photo"
    case  video = "Video" 
}

// Represents a user post
public struct UserPost {
    let identifier: String
    let postType: UserPostType
    let thumbnailImage: URL
    let postURL: URL  // either video url or full resolution photo
    let caption: String?
    let liceCount: [PostLike]
    let comments: [PostComment]
    let createdDate: Date
    let taggedUsers: [String]
    let owner: User
}

struct PostLike {
let username: String
let postIdentifier: String
}

struct CommentLike {
let username: String
let commentIdentifier: String
}


struct PostComment {
let identifier: String
let username: String
let text: String
let createDate: Date
let likes: [CommentLike]
}


