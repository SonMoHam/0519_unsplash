//
//  UserListVC.swift
//  0519_unsplash
//
//  Created by 손대홍 on 2021/05/19.
//

import Foundation
import UIKit

class PhotoCollectionVC: BaseVC {
    var paramSearchCount = 0
    
    @IBOutlet weak var searchPhotoCountLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchPhotoCountLbl.text = "검색 결과 개수: " + String(paramSearchCount)
        print("PhotoCollectionVC - viewDidLoad() called")
    }
}
