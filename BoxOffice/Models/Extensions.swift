//
//  Extensions.swift
//  BoxOffice
//
//  Created by Hyeontae on 05/01/2019.
//  Copyright © 2019 onemoon. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let didReceiveMovieDetailData: Notification.Name = Notification.Name("didReceiveDetailData")
    static let didRecieveCommentData: Notification.Name = Notification.Name("didRecieveCommentData")
    static let detailNetworkError: Notification.Name = Notification.Name("detailNetworkError")
    static let detailCommentsNetworkError: Notification.Name = Notification.Name("detailCommentsError")
}

