//
//  LoginController.swift
//  RxSwift_Part1
//
//  Created by shengling on 2018/6/11.
//  Copyright © 2018年 ShengLing. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var animationView: UIView!
    
    let disposeBag = DisposeBag()
    
    var keyboard = KeyBoard()
    
    lazy var viewModel: LoginViewModel = {
        return LoginViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        eventHandler()
        // Do any additional setup after loading the view.
    }
    
    func configureUI() {
        loginButton.setBackgroundImage(UIImage.imageFromColor(color: .black), for: .normal)
        loginButton.setBackgroundImage(UIImage.imageFromColor(color: UIColor.darkGray), for: .disabled)
    }
    
    func eventHandler() {
        
        loginButton.rx.tap.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .flatMapLatest {_ in self.viewModel.login() }
            .doOnNext { _ in self.performSegue(withIdentifier: "loginSegue", sender: nil)}
            .subscribe().disposed(by: disposeBag)
        nameTextField.rx.text
            .orEmpty.asDriver().drive(viewModel.name)
            .disposed(by: disposeBag)
        viewModel.name
            .asDriver()
            .drive(nameTextField.rx.text)
            .disposed(by: disposeBag)
        passwordTextField.rx.text
            .orEmpty.asObservable()
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        Observable<Bool>
            .combineLatest(nameTextField.rx.text.asObservable(), passwordTextField.rx.text.asObservable()) { (name, password) -> Bool in
                return (name?.utf8.count)! > 4 && (password?.utf8.count)! >= 6 }
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        keyboard.rx.height.asObservable()
            .distinctUntilChanged()
            .doOnNext { (height) in
                let originalBottom = self.animationView.frame.height + self.animationView.frame.origin.y
                var offset = originalBottom + height - UIScreen.main.bounds.height
                offset = offset > 0 ? offset : 0
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    let constant: CGFloat = offset != 0 ? 20 : 40
                    self.titleTopConstraint.constant = constant
                    self.titleBottomConstraint.constant = constant
                    self.animationView.transform = CGAffineTransform.init(translationX: 0, y: -offset)
                    self.view.layoutIfNeeded()
                }, completion: nil) }
            .subscribe().disposed(by: disposeBag)
    }
    
    @IBAction func didClick(_  : UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

extension LoginController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self.view
    }
}
