//
//  UILocalizedIndexedCollation+Sort.swift
//  iGolaIndexSortView
//
//  Created by guan_xiang on 2019/7/23.
//  Copyright © 2019 iGola_iOS. All rights reserved.
//

import UIKit
//MARK: 排序对象model
@objcMembers
class SortModel{
    var sortValue: String?
}

extension UILocalizedIndexedCollation{
    //MARK: 排序成功处理
    typealias successHandler = (_ dataArray : [[SortModel]], _ sectionTitlesArray : [String]) -> Void
    
    //MARK: 成功后 --- 得到对应的标题文字数组 以及对应分组中数据
    static func getCurrentKeysAndObjectsData(needSortArray : NSArray, finishCallback : @escaping successHandler) -> Void{
        
        // 数据源
        var dataArray = [[SortModel]]()
        // 每个section的标题
        var sectionTitleArray = [String]()
        
        let indexedCollation = self.current()
        
        var sortArray = [SortModel]()
        
        for sortObj in needSortArray {
            let sort = SortModel()
            sort.sortValue = sortObj as? String
            sortArray.append(sort)
        }
        
        // 获得索引数, 这里是27个（26个字母和1个#）
        let indexCount = indexedCollation.sectionTitles.count
        
        // 每一个一维数组可能有多个数据要添加，所以只能先创建一维数组，到时直接取来用
        for _ in 0..<indexCount {
            let array = [SortModel]()
            dataArray.append(array)
        }
        
        // 将数据进行分类，存储到对应数组中
        for sortObj in sortArray {
            
            // 根据 SortObjectModel 的 objValue 判断应该放入哪个数组里
            // 返回值就是在 indexedCollation.sectionTitles 里对应的下标
            let sectionNumber = indexedCollation.section(for: sortObj, collationStringSelector: #selector(getter: SortModel.sortValue))
            
            // 添加到对应一维数组中
            dataArray[sectionNumber].append(sortObj)
        }
        
        // 对每个已经分类的一维数组里的数据进行排序，如果仅仅只是分类可以不用这步
        for i in 0..<indexCount {
            
            // 排序结果数组
            let sortedPersonArray = indexedCollation.sortedArray(from: dataArray[i], collationStringSelector: #selector(getter: SortModel.sortValue))
            // 替换原来数组
            dataArray[i] = sortedPersonArray as? [SortModel] ?? []
        }
        
        // 用来保存没有数据的一维数组的下标
        var tempArray = [Int]()
        
        for (i, array) in dataArray.enumerated() {
            
            if array.count == 0 {
                tempArray.append(i)
            } else {
                // 给标题数组添加数据
                sectionTitleArray.append(indexedCollation.sectionTitles[i])
            }
        }
        
        // 删除没有数据的数组
        for i in tempArray.reversed() {
            dataArray.remove(at: i)
        }
        
        //将得到新的 分组数据以及标题数组
        finishCallback(dataArray, sectionTitleArray)
        
    }
}
