//
//  ListController.swift
//  RxSwift_Part1
//
//  Created by shengling on 2018/6/13.
//  Copyright © 2018年 ShengLing. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import MJRefresh

class ListController: UIViewController {
    
    @IBOutlet weak var dataTableView: UITableView!
    
    var dataSource: [Resale] = []
    
    let viewModel = ListViewModel()
    
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func configureTableView() {
        dataTableView.register(UINib(nibName: "\(ResaleListCell.self)", bundle: nil), forCellReuseIdentifier: "\(ResaleListCell.self)")
        dataTableView.separatorStyle = .none
        dataTableView.dataSource = self
        dataTableView.delegate = self
        
        dataTableView.rx.refresh
            .flatMapLatest { _ in self.viewModel.refresh() }
            .subscribe(onNext: { (resales: [Resale]) in
                self.dataSource = resales
                self.dataTableView.reloadData()
                self.dataTableView.mj_header.endRefreshing()
            }).disposed(by: disposeBag)
        dataTableView.rx.loadmore
            .flatMapLatest { _ in self.viewModel.refresh(false) }
            .scan(dataSource) { self.dataSource + $1 }
            .subscribe(onNext: { (resales: [Resale]) in
                self.dataSource = resales.count == 0 ? self.dataSource : resales
                self.dataTableView.reloadData()
                self.dataTableView.mj_footer.endRefreshing()
            }).disposed(by: disposeBag)
        viewModel.more.asObservable().bind(to: dataTableView.rx.footerHidden).disposed(by: disposeBag)
        
//        dataTableView.rx.items(dataSource: RxTableViewDataSourceType & UITableViewDataSource)
        
    
        
//        let data =  RxTableViewSectionedReloadDataSource { (_, tableView, indexPath, item) -> UITableViewCell in
//            return UITableViewCell()
//        }
    }

}

extension ListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ResaleListCell.self)") as? ResaleListCell
        cell?.display(for: dataSource[indexPath.section])
        return cell!
    }
}

extension ListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView(tableView, didDeselectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}



