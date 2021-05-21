//
//  Constants.swift
//  0519_unsplash
//
//  Created by 손대홍 on 2021/05/19.
//

import Foundation

enum SEGUE_ID {
    static let USER_LIST_VC = "goToUserListVC"
    static let PHOTO_COLLECTION_VC = "gotoPhotoCollectionVC"
}

enum API {
    static let BASE_URL: String = "https://api.unsplash.com/"
    static let CLIENT_ID: String = "IEq6PHYVZrVHSSZyOzMr5k38TvyPbBmw42ft2s9LpyM"
}

enum NOTIFICATION {
    enum API {
        static let AUTH_FAIL = "authentication - fail"
    }
}
