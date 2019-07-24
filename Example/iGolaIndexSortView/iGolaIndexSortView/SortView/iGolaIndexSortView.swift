//
//  iGolaIndexSortView.swift
//  iGolaIndexSortView
//
//  Created by guan_xiang on 2019/7/23.
//  Copyright © 2019 iGola_iOS. All rights reserved.
//

import UIKit
protocol iGolaIndexSortViewDelegate: class {
    func indexDidChanged(sortView: iGolaIndexSortView, index: Int, title: String)
}

//MARK: - 排序索引view
class iGolaIndexSortView: UIView {

    weak var delegate: iGolaIndexSortViewDelegate?
    
    /// 排序数据
    private var titles: [String] = []
    
    /// 样式设置
    private var style: iGolaIndexStyle = iGolaIndexStyle()
    
    /// 记录上一个选中的索引
    private var preIndex: Int = -1
    
    /// 记录上一个选中的label
    private weak var preLabel: UILabel?
    
    /// 所有titlesLabel数组
    private lazy var lableArray : [UILabel] = []
    
    /// 指示器view
    private lazy var indicatorView : iGolaIndicatorView = {
       let indicatorView = iGolaIndicatorView(frame: self.style.indicatorFrame, style: self.style)
        indicatorView.alpha = 0
        return indicatorView
    }()
    
    /// 当被点击时，禁止其他任何事件
    private var canHandlerOthersEvent : Bool = true
    
    
    class func sortView(frame: CGRect, style: iGolaIndexStyle, titles: [String]) -> iGolaIndexSortView{
        let sortView = iGolaIndexSortView(frame: frame, style: style, titles: titles)
        return sortView
    }
    
    init(frame: CGRect, style: iGolaIndexStyle, titles: [String]){
        super.init(frame: frame)
        self.titles = titles
        self.style = style
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 计算sortView实际高度
        var rect = self.frame
        rect.size.height = CGFloat(titles.count) * style.sectionHeight + CGFloat(titles.count - 1) * style.margin
        rect.origin.y = (superview?.bounds.size.height ?? 0 - rect.size.height) * 0.4
        self.frame = rect
    }
    
    /// 是否可以处理其他事件
    public func canHanderEvent() -> Bool{
        return canHandlerOthersEvent
    }
}

//MARK: - 选中index label
extension iGolaIndexSortView{
    /// 更新当前选中的label状态
    public func updateLabelStatus(index: Int){
        if index > titles.count - 1 { return }
        
        preLabel?.backgroundColor = UIColor.clear
        preLabel?.textColor = style.textColor
        
        let selectedLabel = lableArray[index]
        selectedLabel.textColor = style.selectedColor
        selectedLabel.backgroundColor = style.selectedBgColor
        preLabel = selectedLabel
    }
}

//MARK: - 手势事件
extension iGolaIndexSortView{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        canHandlerOthersEvent = false
        indicatorView.alpha = 1
        
        guard let point = event?.touches(for: self)?.first?.location(in: self) else {
            return
        }
        
        selectedTitle(point: point)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        canHandlerOthersEvent = true
        UIView.animate(withDuration: 0.2) {
            self.indicatorView.alpha = 0
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard let point = event?.touches(for: self)?.first?.location(in: self) else {
            return
        }
        
        selectedTitle(point: point)
    }
    
    private func selectedTitle(point: CGPoint){
        if point.x < 0 ||
            point.y < 0 ||
            point.x > self.bounds.size.width ||
            point.y > self.bounds.size.height{
            return
        }
        
        var number: Int = 0
        var title: String = ""
        for (index, titleLabel) in lableArray.enumerated(){
            if point.y < (titleLabel.frame.maxY + 0.5 * style.margin){
                preLabel?.textColor = style.textColor
                preLabel?.backgroundColor = UIColor.clear
                
                titleLabel.textColor = style.selectedColor
                titleLabel.backgroundColor = style.selectedBgColor
                preLabel = titleLabel
                number = index
                title = titleLabel.text ?? ""
                break
            }
        }
        
        
        if preIndex == number { return }
        preIndex = number
        indicatorView.center = CGPoint(x: indicatorView.center.x, y: preLabel?.center.y ?? 0)
        indicatorView.title = title
        
        /// 触觉反馈效果
        if #available(iOS 10.0, *) {
            let gen = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.light)
            gen.prepare()
            gen.impactOccurred()
        }
        
        delegate?.indexDidChanged(sortView: self, index: number, title: title)
    }
}

//MARK: - UI
extension iGolaIndexSortView{
    private func setupSubviews(){
        while self.subviews.count != 0 {
            self.subviews.last?.removeFromSuperview()
        }
        
        preIndex = -1
        
        indicatorView.alpha = 0
        addSubview(indicatorView)
        
        // 添加labels
        let labelWH = style.sectionHeight
        let labelX = (self.bounds.size.width - labelWH) * 0.5
        lableArray.removeAll()
        titles.enumerated().forEach { (index, item) in
            let labelY = (labelWH + style.margin) * CGFloat(index)
            
            let sortLabel = UILabel(frame: CGRect(x: labelX, y: labelY, width: labelWH, height: labelWH))
            sortLabel.text = item.uppercased()
            sortLabel.textAlignment = .center
            sortLabel.font = style.textFont
            sortLabel.textColor = style.textColor
            sortLabel.backgroundColor = UIColor.clear
            sortLabel.layer.cornerRadius = labelWH * 0.5
            sortLabel.clipsToBounds = true
            addSubview(sortLabel)
            lableArray.append(sortLabel)
        }
        
        // 默认选中0
        if titles.count > 0{
            updateLabelStatus(index: 0)
        }
    }
}


//MARK: - 指示器View
class iGolaIndicatorView: UIView {
    private var style : iGolaIndexStyle = iGolaIndexStyle()
    
    public var title: String = ""{
        didSet{
            indexLabel.text = title
        }
    }
    
    private lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.textColor = self.style.indicatorTextColor
        label.font = self.style.indicatorFont
        label.textAlignment = NSTextAlignment.center
        label.frame = self.bounds
        return label
    }()
    
    init(frame: CGRect, style: iGolaIndexStyle){
        super.init(frame: frame)
        self.style = style
        addSubview(indexLabel)
        
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        drawInContext(context: context)
    }
    
    private func drawInContext(context: CGContext){
        context.setLineWidth(2.0)
        context.setFillColor(style.indicatorBgColor.cgColor)
        getDrawPath(context: context)
        context.fillPath()
    }
    
    private func getDrawPath(context: CGContext){
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        let offsetX = self.bounds.size.width * 0.25
        let offsetY = self.bounds.size.height * 0.25
        let radius = sqrt(pow(offsetX, 2.0) + pow(offsetY, 2.0))
        
        context.move(to: CGPoint(x: width - offsetX, y: height * 0.5 - offsetY))
        context.addLine(to: CGPoint(x: width, y: height * 0.5))
        context.addLine(to: CGPoint(x: width - offsetX, y: height * 0.5 + offsetY))
        
        context.addArc(tangent1End: CGPoint(x: width * 0.5, y: height), tangent2End: CGPoint(x: width * 0.5 - offsetX, y: height * 0.5 + offsetY), radius: radius)
        
        context.addArc(tangent1End: CGPoint(x: 0, y: height * 0.5), tangent2End: CGPoint(x: width * 0.5 - offsetX, y: height * 0.5 - offsetY), radius: radius)
        
        context.addArc(tangent1End: CGPoint(x: width * 0.5, y: 0), tangent2End: CGPoint(x: width * 0.5 + offsetX, y: height * 0.5 - offsetY), radius: radius)
        
        context.closePath()
    }
}

