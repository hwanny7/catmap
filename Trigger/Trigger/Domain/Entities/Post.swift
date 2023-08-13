//
//  Post.swift
//  Trigger
//
//  Created by yun on 2023/08/13.
//

import UIKit


struct Post {
    var title: String
    var content: String
    var isPublic: Bool = true
    var imageList: [UIImage] = [UIImage(systemName: "camera")!]
}
