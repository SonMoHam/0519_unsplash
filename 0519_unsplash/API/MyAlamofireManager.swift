//
//  MyAlamofireManager.swift
//  0519_unsplash
//
//  Created by 손대홍 on 2021/05/21.
//

import Foundation
import Alamofire

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
}
