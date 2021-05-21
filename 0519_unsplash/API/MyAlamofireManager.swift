//
//  MyAlamofireManager.swift
//  0519_unsplash
//
//  Created by 손대홍 on 2021/05/21.
//

import Foundation
import Alamofire

final class MyAlamofireManager {
    
    // 싱글턴 적용
    static let shared = MyAlamofireManager()
    
    // 인터셉터
    let interceptors = Interceptor(interceptors:
                        [
                            BaseInterceptor()
                        ])
    
    // 로거
//    let monitors =
    
    // 세션 설정
    var session: Session
    
    private init() {
        session = Session(interceptor: interceptors)
    }
}
