//
//  ViewController.swift
//  0519_unsplash
//
//  Created by 손대홍 on 2021/05/19.
//

import UIKit
import Toast_Swift
import Alamofire

class HomeVC: BaseVC, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("HomeVC - prepare() called / segue.identifier : \(segue.identifier!)")
        
        switch segue.identifier {
        case SEGUE_ID.PHOTO_COLLECTION_VC:
            let nextVC = segue.destination as! PhotoCollectionVC
            guard let userInputValue = self.searchBar.text else { return }
            
            nextVC.vcTitle = "searchPhotos \n inputValue: " + userInputValue
        
        case SEGUE_ID.USER_LIST_VC:
            // 다음 화면 뷰컨트롤러 인스턴스
            let nextVC = segue.destination as! UserListVC
            guard let userInputValue = self.searchBar.text else { return }
            
            nextVC.vcTitle = "searchUsers \n inputValue: " + userInputValue
        default:
            print("default")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("HomeVC - viewDidAppear() called")
        self.searchBar.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("HomeVC - viewWillAppear() called")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShowHandle(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHideHandle(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("HomeVC - viewWillDisappear() called")
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - fileprivate methods
    
    fileprivate func config() {
        self.searchButton.layer.cornerRadius = 10
        self.searchBar.searchBarStyle = .minimal
        
        self.searchBar.delegate = self
        self.keyboardDismissTabGesture.delegate = self
        
        // 제스처 추가
        self.view.addGestureRecognizer(keyboardDismissTabGesture)
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
    
    @objc func keyboardWillShowHandle(notification: NSNotification) {
        print("HomeVC - keyboardWillShowHandle() called")
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("keyboardSize.height: \(keyboardSize.height)")
            print("searchButton.frame.origin.y: \(searchButton.frame.origin.y)")
            
            if keyboardSize.height < searchButton.frame.origin.y {
                print("키보드 버튼 가림")
                self.view.frame.origin.y = keyboardSize.height - searchButton.frame.origin.y - searchButton.frame.height
            }
        }
        
        
        //        self.view.frame.origin.y = -100
    }
    
    @objc func keyboardWillHideHandle(notification: NSNotification) {
        print("HomeVC - keyboardWillHideHandle() called")
        self.view.frame.origin.y = 0
    }
    
    // MARK: - IBAction methods
    
    @IBAction func onSearchButtonClicked(_ sender: UIButton) {
        print("HomeVC - onSearchButtonClicked() called / selectedIndex: \(self.searchFilterSegment.selectedSegmentIndex)")
        
        //        let url = API.BASE_URL + "search/photos"
        //        let queryParam = ["query": userInput, "client_id": API.CLIENT_ID]
        
        guard let userInput = self.searchBar.text else { return }
        //        var urlToCall: URLRequestConvertible?
        
        switch searchFilterSegment.selectedSegmentIndex {
        case 0:
            //            urlToCall = MySearchRouter.searchPhotos(term: userInput)
            MyAlamofireManager
                .shared  // 싱글톤 static 프로퍼티 접근
                .getPhotos(searchTerm: userInput,
                           
                           // 클로저 ARC 관련
                           // self 는 메모리 카운트 증가시킴
                           // weak self 사용, 메모리 가지고 있는 것 방지
                           completion: { [weak self] result in
                            guard let self = self else { return }
                            
                            switch result {
                            case .success(let fetchedPhotos):
                                print("HomeVC - getPhotos.success - fetchedPhotos.count: \(fetchedPhotos.count)")
                                self.view.makeToast("success - fetchedPhotos.count: \(fetchedPhotos.count)", duration: 2.0, position: .center)
                            case .failure(let error):
                                print("HomeVC - getPhotos.failure - error: \(error.rawValue)")
                                self.view.makeToast("\(error.rawValue)", duration: 1.0, position: .center)
                            }
                           })
        case 1:
            MyAlamofireManager
                .shared  // 싱글톤 static 프로퍼티 접근
                .getUsers(searchTerm: userInput,
                          
                          // 클로저 ARC 관련
                          // self 는 메모리 카운트 증가시킴
                          // weak self 사용, 메모리 가지고 있는 것 방지
                          completion: { [weak self] result in
                            guard let self = self else { return }
                            
                            switch result {
                            case .success(let fetchedUsers):
                                print("HomeVC - getUsers.success - fetchedUsers.count: \(fetchedUsers.count)")
                                self.view.makeToast("success - fetchedUsers.count: \(fetchedUsers.count)", duration: 2.0, position: .center)
                            case .failure(let error):
                                print("HomeVC - getUsers.failure - error: \(error.rawValue)")
                                self.view.makeToast("\(error.rawValue)", duration: 1.0, position: .center)
                            }
                          })
        default:
            print("default")
        }
        
        //        if let urlConvertible = urlToCall {
        //            MyAlamofireManager
        //                .shared                 // 싱글톤 static 프로퍼티 접근
        //                .session
        //                .request(urlConvertible)
        //                .validate(statusCode: 200...400)
        //                .responseJSON(completionHandler: { response in
        //                    debugPrint(response)
        //                })
        //        }
        
        
        //        AF.request(url, method: .get, parameters: queryParam).responseJSON(completionHandler: { response in
        //            debugPrint(response)
        //        })
        
        // 화면으로 이동
        //        pushVC()
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
        } else {
            view.endEditing(true)
            print("화면 터치")
            return true
        }
    }
    
    
}

