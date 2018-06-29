//
//  PlainController.swift
//  iOS_MVVM_Demo
//
//  Created by shengling on 2018/6/29.
//  Copyright © 2018 ShengLing. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PlainController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = PlainViewModel()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        viewModel.refresh().bind(to: tableView.rx.items(cellIdentifier: "PlainCell", cellType: PlainCell.self)) { (index, item, cell) in
            cell.item = item
        }.disposed(by: disposeBag)
        
        tableView.estimatedRowHeight = 100
        
        // Do any additional setup after loading the view.
    }


}
