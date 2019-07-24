# iGolaIndexSortView tableView右边排序索引
tableView右边排序索引 A～～Z #

### 初始化
```swift
let sortView = iGolaIndexSortView(frame: CGRect(x: self.view.bounds.size.width - 30, y: 0, width: 30, height: self.view.bounds.size.height), style: iGolaIndexStyle(), titles: titleArray)
```

### 使用
```swift
let testArray = ["赵无极","钱三","孙四","李武","里啊","周吧","吴的","郑我","王飞","秦去","亲俄","还跳","好","赵","钱","孙","李","里","周","吴","郑","王","秦","亲","还","好","赵","钱","孙","李","里","周","吴","郑","王","秦","亲","还","好","#","da","阿啊","abc","dd", "dc", "ad","abs","ab", "b", "Bs", "ba","南宁","南边变","南边a","南方","男人"]

// 排序
UILocalizedIndexedCollation.getCurrentKeysAndObjectsData(needSortArray: testArray as NSArray) { (dataArray,titleArray) in
    self.dataArray = dataArray
    self.sortArray = titleArray
    self.tableView.reloadData()

    let sortView = iGolaIndexSortView(frame: CGRect(x: self.view.bounds.size.width - 30, y: 0, width: 30, height: self.view.bounds.size.height), style: iGolaIndexStyle(), titles: titleArray)
    self.view.addSubview(sortView)
    sortView.delegate = self
    self.sortView = sortView
}
```

### iGolaIndexSortViewDelegate代理方法
```swift
//MARK: - required
func indexDidChanged(sortView: iGolaIndexSortView, index: Int, title: String) {
    self.tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: UITableView.ScrollPosition.top, animated: false)
}
```


### 外界tableview代理方法修改sortView选中
```swift
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let sortView = self.sortView else {
        return
    }
    let indexPath = tableView.indexPathForRow(at: scrollView.contentOffset)
    if sortView.canHanderEvent(){
        sortView.updateLabelStatus(index: indexPath?.section ?? 0)
    }
}
```


