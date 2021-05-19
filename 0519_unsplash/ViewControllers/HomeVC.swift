//
//  ViewController.swift
//  0519_unsplash
//
//  Created by 손대홍 on 2021/05/19.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var searchFilterSegment: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchIndicator: UIActivityIndicatorView!
    
    
    
    // MARK: - override method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.searchButton.layer.cornerRadius = 10
        
        self.searchBar.searchBarStyle = .minimal
    }


    // MARK: - IBAction methods
    
    @IBAction func onSearchButtonClicked(_ sender: UIButton) {
        print("HomeVC - onSearchButtonClicked() called / selectedIndex: \(self.searchFilterSegment.selectedSegmentIndex)")
        var segueId: String = ""
        
        switch self.searchFilterSegment.selectedSegmentIndex {
        case 0:
            print("사진 화면으로 이동")
            segueId = "goToPhotoCollectionVC"
        case 1:
            print("사용자 화면으로 이동")
            segueId = "goToUserListVC"
        default:
            print("default")
            segueId = "goToPhotoCollectionVC"
        }
        
        // 화면 이동
        self.performSegue(withIdentifier: segueId, sender: self)
    }
    
    @IBAction func searchFilterValueChanged(_ sender: UISegmentedControl) {
        print("homeVC - searchFilterValueChanged() called / index = \(sender.selectedSegmentIndex)")
        var searchBarTitle: String = ""
        switch sender.selectedSegmentIndex{
        case 0:
            searchBarTitle = "사진 키워드"
        case 1:
            searchBarTitle = "사용자 이름"
        default:
            searchBarTitle = "사진 키워드"
        }
        
        self.searchBar.placeholder = searchBarTitle + " 입력"
        // 포커싱
        self.searchBar.becomeFirstResponder()
        // 포커싱 해제
//        self.searchBar.resignFirstResponder()
    }
}

