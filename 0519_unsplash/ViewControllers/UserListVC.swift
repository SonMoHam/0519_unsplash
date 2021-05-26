//
//  UserListVC.swift
//  0519_unsplash
//
//  Created by 손대홍 on 2021/05/19.
//

import Foundation
import UIKit

class UserListVC: BaseVC {
    var paramSearchCount = 0

    @IBOutlet weak var searchUserCountLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchUserCountLbl.text = "유저 검색 결과 개수: " + String(paramSearchCount)
        
        print("UserListVC - viewDidLoad() called")
    }
}
