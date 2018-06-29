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
    
    let viewModel = ListViewModel()
    
    let disposeBag = DisposeBag()
    
    var dataSource: RxTableViewSectionedReloadDataSource<RepoSection>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func configureTableView() {
        dataTableView.register(UINib(nibName: "\(RepoCell.self)", bundle: nil), forCellReuseIdentifier: "\(RepoCell.self)")
        dataTableView.separatorStyle = .none
//        dataTableView.dataSource = self
//        dataTableView.delegate = self
        

        dataSource = RxTableViewSectionedReloadDataSource<RepoSection>(configureCell: { (sectionModel, tableView, indexPath, repo) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(RepoCell.self)") as? RepoCell
            cell?.display(for: repo)
            return cell!
        })
        
        
        
        dataTableView.rx.refresh
            .flatMapLatest { _ in self.viewModel.refresh() }
            .doOnNext { _ in
                self.dataTableView.reloadData()
                self.dataTableView.mj_header.endRefreshing()
            }
            .subscribe()
            .disposed(by: disposeBag)
        dataTableView.rx.loadmore
            .flatMapLatest { _ in self.viewModel.refresh(false) }
            .doOnNext { _ in
                self.dataTableView.reloadData()
                self.dataTableView.mj_header.endRefreshing()
            }
            .subscribe().disposed(by: disposeBag)
        
        viewModel.sections.bind(to: dataTableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        viewModel.more.asObservable().bind(to: dataTableView.rx.footerHidden).disposed(by: disposeBag)
        
        dataTableView.estimatedRowHeight = 120
        dataTableView.sectionHeaderHeight = 10
        

    }

}

//extension ListController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return dataSource.count
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "\(RepoCell.self)") as? RepoCell
//        cell?.display(for: dataSource[indexPath.section])
//        return cell!
//    }
//}

//extension ListController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        tableView(tableView, didDeselectRowAt: indexPath)
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 128
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0.1
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 10
//    }
//}



