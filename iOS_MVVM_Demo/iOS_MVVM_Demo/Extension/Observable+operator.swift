//
//  Observable+operator.swift
//  RxSwift_Part1
//
//  Created by shengling on 2018/6/11.
//  Copyright © 2018年 ShengLing. All rights reserved.
//

import Foundation
import RxSwift

extension Observable {
    func doOnNext(_ closure: @escaping (Element) -> Void) -> Observable<Element> {
        return self.do(onNext: { (element) in
            closure(element)
        })
    }
    
    func doOnError(_ closure: @escaping (Error) -> Void) -> Observable<Element> {
        return self.do(onError: { (error) in
            closure(error)
        })
    }
    
    func doOnCompleted(_ closure: @escaping () -> Void) ->  Observable<Element> {
        return self.do(onCompleted: {
            closure()
        })
    }
    
    func doOnSubscribe(_ closure: @escaping () -> Void) -> Observable<Element> {
        return self.do(onSubscribe: {
            closure()
        })
    }
    
    func doOnDisposed(_ closure: @escaping () -> Void)-> Observable<Element> {
        return self.do(onDispose: {
            closure()
        })
    }
}

//protocol OptionalType {
//    associatedtype Wrapped
//
//    var value: Wrapped? { get }
//}
//
//extension Optional: OptionalType {
//    var value: Wrapped? {
//        return self
//    }
//}
//
//extension Observable where Element: OptionalType {
//    func filterNilKeepOptional() -> Observable<Element> {
//        return self.filter { (element) -> Bool in
//            return element.value != nil
//        }
//    }
//}
