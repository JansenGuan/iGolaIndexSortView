//
//  ViewController.swift
//  iGolaIndexSortView
//
//  Created by guan_xiang on 2019/7/23.
//  Copyright © 2019 iGola_iOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var dataArray: [[SortModel]] = []
    
    lazy var sortArray : [String] = []
    
    /// tableview
    lazy var tableView : UITableView = {
        let tableview = UITableView(frame: self.view.bounds, style: .plain)
        tableview.dataSource = self
        tableview.delegate = self
        return tableview
    }()
    
    private weak var sortView: iGolaIndexSortView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        
        //测试数据
        let testArray = ["赵无极","钱三","孙四","李武","里啊","周吧","吴的","郑我","王飞","秦去","亲俄","还跳","好","赵","钱","孙","李","里","周","吴","郑","王","秦","亲","还","好","赵","钱","孙","李","里","周","吴","郑","王","秦","亲","还","好","#","da","阿啊","abc","dd", "dc", "ad","abs","ab", "b", "Bs", "ba","南宁","南边变","南边a","南方","男人"]
        
        //基于 UILocalizedIndexedCollation 调用其方法
        UILocalizedIndexedCollation.getCurrentKeysAndObjectsData(needSortArray: testArray as NSArray) { (dataArray,titleArray) in
            self.dataArray = dataArray
            self.sortArray = titleArray
            self.tableView.reloadData()
            
            let sortView = iGolaIndexSortView(frame: CGRect(x: self.view.bounds.size.width - 30, y: 0, width: 30, height: self.view.bounds.size.height), style: iGolaIndexStyle(), titles: titleArray)
            self.view.addSubview(sortView)
            sortView.delegate = self
            self.sortView = sortView
        }
    }
}

extension ViewController: iGolaIndexSortViewDelegate{
    func indexDidChanged(sortView: iGolaIndexSortView, index: Int, title: String) {
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: UITableView.ScrollPosition.top, animated: false)
    }
}

//MARK: - tableView数据源代理方法
extension ViewController : UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArray[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = model.sortValue
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortArray[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let sortView = self.sortView else {
            return
        }
        let indexPath = tableView.indexPathForRow(at: scrollView.contentOffset)
        if sortView.canHanderEvent(){
            sortView.updateLabelStatus(index: indexPath?.section ?? 0)
        }
    }
}
