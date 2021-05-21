//
//  BaseVC.swift
//  0519_unsplash
//
//  Created by 손대홍 on 2021/05/19.
//

import Foundation
import UIKit
import Toast_Swift

class BaseVC: UIViewController {
    var vcTitle: String = "" {
        didSet {
            print("UserListVC - vcTitle didSet() called / vcTitle : \(vcTitle)")
            self.title = vcTitle
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 인증 실패 노티피케이션 등록
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showErrorPopUp(notification:)),
                                               name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL),
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL),
                                                  object: nil)
    }
    
    //MARK: - objc methods
    
    @objc func showErrorPopUp(notification: NSNotification){
        print("BaseVC - showErrorPopUp()")
        
        if let data = notification.userInfo?["statusCode"] {
            print("showErrorPopUp() data: \(data)")
            
            // 메인쓰레드에서 실행 (UI 스레드)
            DispatchQueue.main.async {
                self.view.makeToast("\(data) 에러입니다.", duration: 1.0, position: .center)
            }
            
            
        }
    }
}
