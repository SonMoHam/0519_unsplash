//
//  BaseVC.swift
//  0519_unsplash
//
//  Created by 손대홍 on 2021/05/19.
//

import Foundation
import UIKit

class BaseVC: UIViewController {
    var vcTitle: String = "" {
        didSet {
            print("UserListVC - vcTitle didSet() called / vcTitle : \(vcTitle)")
            self.title = vcTitle
        }
    }
}
