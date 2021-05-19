//
//  ViewController.swift
//  0519_unsplash
//
//  Created by 손대홍 on 2021/05/19.
//

import UIKit
import Toast_Swift

class HomeVC: UIViewController, UISearchBarDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var searchFilterSegment: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchIndicator: UIActivityIndicatorView!
    
    var keyboardDismissTabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    
    // MARK: - override method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.config()
    }

    // MARK: - fileprivate methods
    
    fileprivate func config() {
        self.searchButton.layer.cornerRadius = 10
        
        self.searchBar.searchBarStyle = .minimal
        
        self.searchBar.delegate = self
        
        self.keyboardDismissTabGesture.delegate = self
        
        // 제스처 추가
        self.view.addGestureRecognizer(keyboardDismissTabGesture)
        self.searchBar.becomeFirstResponder()
    }
    
    
    fileprivate func pushVC() {
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
    
    // MARK: - IBAction methods
    
    @IBAction func onSearchButtonClicked(_ sender: UIButton) {
        print("HomeVC - onSearchButtonClicked() called / selectedIndex: \(self.searchFilterSegment.selectedSegmentIndex)")
        pushVC()
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
    
    //MARK: - UISearchBar Delegate methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("HomeVC - searchBarSearchButtonClicked() called")
    
        guard let userInputString = searchBar.text else { return }
        if userInputString.isEmpty {
            self.view.makeToast("검색 키워드를 입력해주세요.", duration: 1.0, position: .center)
        } else {
            pushVC()
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("HomeVC - searchBar textDidChange() / searchText = \(searchText)")
        
        if searchText.isEmpty {
            self.searchButton.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                searchBar.resignFirstResponder()  // 포커싱 해제
            })
        } else {
            self.searchButton.isHidden = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputTextCount = searchBar.text?.appending(text).count ?? 0
        
        print("shouldChangeTextIn: \(inputTextCount)")
        if inputTextCount > 11 {
            self.view.makeToast("12자 까지만 입력 가능합니다.", duration: 1.0, position: .center)
        }
        return inputTextCount <= 12
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("HomeVC - gestureRecognizer shouldReceive() called")
        
        if touch.view?.isDescendant(of: searchFilterSegment) == true {
            print("세그먼트 터치")
            return false
        } else if touch.view?.isDescendant(of: searchBar) == true {
            print("서치바 터치")
            return false
        }
        
        else {
            view.endEditing(true)
            print("화면 터치")
            return true
        }
        
        
    }
}

