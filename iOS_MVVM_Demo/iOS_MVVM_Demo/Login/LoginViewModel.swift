//
//  LoginViewModel.swift
//  RxSwift_Part1
//
//  Created by shengling on 2018/6/11.
//  Copyright © 2018年 ShengLing. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel {
    
    var name: Variable<String> = Variable<String>("")
    var password: Variable<String> = Variable<String>("")
            
    init() {

    }
    
    func login() -> Observable<User> {
        return Networking.default
        .request(AuthRouter.login(name: self.name.value, password: self.password.value), [TokenPlugin(), PrintPlugin()])
        .unwrapper()
        .mapObject(type: User.self)
        .skipWhile{ $0.id == nil }
    }
    
    func save() {
        UserDefaults.standard.set(name.value, forKey: "name")
        UserDefaults.standard.set(password.value, forKey: "password")
        UserDefaults.standard.synchronize()
    }
    
    func auto() {
        if let nameValue = UserDefaults.standard.value(forKey: "name") as? String,
            let passwordValue = UserDefaults.standard.value(forKey: "password") as? String {
            name.value = nameValue
            password.value = passwordValue
        }
    }
    
}
