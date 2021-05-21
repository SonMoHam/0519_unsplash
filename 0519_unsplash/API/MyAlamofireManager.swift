//
//  MyAlamofireManager.swift
//  0519_unsplash
//
//  Created by 손대홍 on 2021/05/21.
//

import Foundation
import Alamofire
import SwiftyJSON

final class MyAlamofireManager {
    
    // 싱글톤 적용
    // 인스턴스를 저장할 static 프로퍼티를 만든다.
    // init() 은 private .
    static let shared = MyAlamofireManager()
    
    // 인터셉터
    let interceptors = Interceptor(interceptors:
                                    [
                                        BaseInterceptor()
                                    ])
    
    // 로거
    let monitors = [ MyLogger(),
//                     MyApiStatusLogger(),
    ] as [EventMonitor]
    
    // 세션 설정
    var session: Session
    
    private init() {
        session = Session(
            interceptor: interceptors,
            eventMonitors: monitors)
    }
    
    func getPhotos(searchTerm userInput: String, completion: @escaping (Result<[Photo], MyError>) -> Void) {
        
        print("MyAlamofireManager - getPhotos() called / userInput: \(userInput)")
        
        self.session
            .request(MySearchRouter.searchPhotos(term: userInput))
            .validate(statusCode: 200...400)
            .responseJSON(completionHandler: { response in
                
                guard let responseValue = response.value else { return }
                
                var photos = [Photo]()
                let responseJson = JSON(responseValue)
                
                let jsonArray = responseJson["results"]
                print("jsonArray.count: \(jsonArray.count)")
                
                for (index, subJson): (String, JSON) in jsonArray {
                    print("index: \(index) , subJSON: \(subJson)")
                    
                    // 데이터 파싱
                    let thumbnail = subJson["urls"]["thumb"].string ?? ""
                    let username = subJson["user"]["username"].string ?? ""
                    let likesCount = subJson["likes"].intValue
                    let createdAt = subJson["created_at"].string ?? ""
                    
                    let photoItem = Photo(thumbnail: thumbnail, username: username, likesCount: likesCount, createdAt: createdAt)
                    // 배열 배정
                    photos.append(photoItem)
                }
                
                if photos.count > 0 {
                    completion(.success(photos))
                } else {
                    completion(.failure(.noContent))
                }
            })
    }
}
