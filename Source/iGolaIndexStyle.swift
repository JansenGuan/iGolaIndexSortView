//
//  iGolaIndexType.swift
//  iGolaIndexSortView
//
//  Created by guan_xiang on 2019/7/23.
//  Copyright © 2019 iGola_iOS. All rights reserved.
//

import UIKit
struct iGolaIndexStyle{
    /// 常量
    private struct iGolaIndexStyleConst {
        static let textColor = UIColor.init(red: 35/255.0, green: 135/255.0, blue: 135/255.0, alpha: 1)
        static let selectedBgColor = UIColor.init(red: 54/255.0, green: 129/255.0, blue: 228/255.0, alpha: 1)
        static let indicatorFrame = CGRect(x: -60, y: 0, width: 50, height: 50)
        static let sectionHeight: CGFloat = 16.0
        static let textFont: UIFont = UIFont.systemFont(ofSize: 14)
        static let indicatorFont: UIFont = UIFont.boldSystemFont(ofSize: 18)
        static let textMargin: CGFloat = 5.0
    }
    
    /// 排序字母行高, label.layer.cornerRadius = sectionHeight * 0.5
    var sectionHeight: CGFloat = iGolaIndexStyleConst.sectionHeight
    
    /// 排序字母上下间距
    var margin: CGFloat = iGolaIndexStyleConst.textMargin
    
    /// 字体
    var textFont: UIFont = iGolaIndexStyleConst.textFont
    
    /// 文字颜色
    var textColor: UIColor = iGolaIndexStyleConst.textColor
    
    /// 文字选中颜色
    var selectedColor: UIColor = UIColor.white
    
    /// 选中背景颜色
    var selectedBgColor: UIColor = iGolaIndexStyleConst.selectedBgColor
    
    
    /// 指示器frame
    var indicatorFrame: CGRect = iGolaIndexStyleConst.indicatorFrame
    
    /// 指示器背景色
    var indicatorBgColor: UIColor = UIColor.lightGray
    
    /// 指示器字体
    var indicatorFont: UIFont = iGolaIndexStyleConst.indicatorFont
    
    /// 指示器文字颜色
    var indicatorTextColor: UIColor = UIColor.white
    
    init(){}

    init(sectionHeight: CGFloat = iGolaIndexStyleConst.sectionHeight,
         textFont: UIFont = iGolaIndexStyleConst.textFont,
         textColor: UIColor = iGolaIndexStyleConst.textColor,
         selectedColor: UIColor = UIColor.white,
         selectedBgColor: UIColor = iGolaIndexStyleConst.selectedBgColor,
         indicatorFrame: CGRect = iGolaIndexStyleConst.indicatorFrame,
         indicatorBgColor: UIColor = UIColor.lightGray,
         indicatorFont: UIFont = iGolaIndexStyleConst.indicatorFont,
         indicatorTextColor: UIColor = UIColor.white) {
        
        self.sectionHeight = sectionHeight
        self.textFont = textFont
        self.textColor = textColor
        self.selectedColor = selectedColor
        self.selectedBgColor = selectedBgColor
        self.indicatorFrame = indicatorFrame
        self.indicatorBgColor = indicatorBgColor
        self.indicatorFont = indicatorFont
        self.indicatorTextColor = indicatorTextColor
    }
}
