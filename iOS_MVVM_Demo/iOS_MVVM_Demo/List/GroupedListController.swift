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



class GroupedListController: UIViewController {
    
    @IBOutlet weak var dataTableView: UITableView!
    
    let viewModel = GroupedViewModel()
    
    let disposeBag = DisposeBag()
    
    var dataSource: RxTableViewSectionedReloadDataSource<RepoSection>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureEvent()
        dataBinder()
    }
    
    func configureTableView() {
        dataTableView.register(UINib(nibName: "\(RepoCell.self)", bundle: nil), forCellReuseIdentifier: "\(RepoCell.self)")
        dataTableView.separatorStyle = .none

        dataSource = RxTableViewSectionedReloadDataSource<RepoSection>(configureCell: { (sectionModel, tableView, indexPath, repo) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(RepoCell.self)") as? RepoCell
            cell?.display(for: repo)
            return cell!
        })
        
        dataTableView.estimatedRowHeight = 120
        dataTableView.sectionHeaderHeight = 10
        
    }
    func dataBinder() {
        viewModel.sections.bind(to: dataTableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        viewModel.more.asObservable().bind(to: dataTableView.rx.footerHidden).disposed(by: disposeBag)
    }
    
    func configureEvent() {
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
    }

}



