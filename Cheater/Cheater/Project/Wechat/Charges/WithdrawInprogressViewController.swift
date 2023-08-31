//
//  WithdrawInprogressViewController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/8/31.
//  Copyright © 2023 xiaoyou. All rights reserved.
//
/*
 * - TODO -
 * 微信提现成功页面
 *
 */

/*
 关于 UI 页面子 view 嵌套层级比较深,共享 VC 公共数据比较困难的事情
 
 可以给每个页面定义个 protocol 来规范获取当前页面的 某些信息.
 view.viewController as? protocol. 来获取当前的页面的公共信息
 
 */


import UIKit
import XYUIKit
import XYInfomationSection

class WithdrawInprogressViewController: XYInfomationBaseViewController {
    private var pageInfo: PageInfo { didSet { updatePageInfo() } }
    /// 到账时间 label
    private var doneTimeLabel: UILabel?
    /// 提现金额 label
    private var withdrawAmountLabel: UILabel?
    /// 到账银行卡信息
    private var bankInfoLabel: UILabel?
    /// 服务费label
    private var feeLabel: UILabel?
    
    init(pageInfo: PageInfo) {
        self.pageInfo = pageInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        loadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }
}

extension WithdrawInprogressViewController {
    
    func buildUI() {
        setupNav()
        setupContent()
    }
    
    func setupNav() {
        navigationController?.navigationBar.barTintColor = .white
        nav_hideBarBottomLine()
        title = "零钱提现"
    }
    
    @objc func navLeftBtnClick(){
        dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func navRightBtnClick(){
        // right item click
    }
    
    func setupContent() {
        view.backgroundColor = .white
        
        // header
        setHeaderView(createHeaderView(), edgeInsets: .init(top: 13, left: 0, bottom: 0, right: 0))
        
        // content
        setContentView(createContentView(), edgeInsets: .
        init(top: 40, left: 0, bottom: 0, right: 0))
        
        // footer
        let btn = UILabel(title: "完成", font: .boldSystemFont(ofSize: 19), textColor: .C_wx_green, textAlignment: .center).boxView(with: .init(top: 9, left: 70, bottom: 9, right: 70))
        btn.backgroundColor = .C_wx_keyboard_bgcolor
        btn.corner(radius: 5)
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-CGFloat.safeBottom-20)
            make.centerX.equalToSuperview()
        }
    }
    
    func updatePageInfo() {
        
        //
        let moneyText = "¥" + self.pageInfo.withdrawAmmount
        self.withdrawAmountLabel?.text = moneyText
        
        //
        let bankInfo = self.pageInfo.bankCard.bank.title + " 尾号 " + self.pageInfo.bankCard.cardNumber
        self.bankInfoLabel?.text = bankInfo
        
        //
        let feeFloat = (max(self.pageInfo.fee.floatValue, 0.1))
        let feeText = "¥" + String(format: "%.2f", feeFloat)
        self.feeLabel?.text = feeText
        
        //
        let doneText = "预计 \(pageInfo.doneTime) 前到账"
        self.doneTimeLabel?.text = doneText
    }
    
    func createContentView() -> UIView {
        let headerView = UIView.init()
        
        let line = UIView.line
        
        let vStack = VStack(spacing: 15)
        vStack.alignment = .leading
        
        let info1 = createInfoView(index: 1)
        vStack.addArrangedSubview(info1)
        info1.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        let info2 = createInfoView(index: 2)
        vStack.addArrangedSubview(info2)
        info2.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        let info3 = createInfoView(index: 3)
        vStack.addArrangedSubview(info3)
        info3.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        headerView.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalToSuperview()
            make.height.equalTo(CGFloat.line)
        }
        
        headerView.addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.left.top.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalToSuperview()
        }
        
        // config
        headerView.addTap {[weak self] sender in
            guard let self = self else { return }
            self.gotoEdit()
        }
        
        return headerView
    }
    
    func createInfoView(index: Int) -> UIView {
        
        switch index {
        case 1:
            let hStack = UIView()
            let titleLabel = UILabel(title: "提现金额", font: .systemFont(ofSize: 15), textColor: .C_wx_tip_text, textAlignment: .left)
            
            let text = "¥" + self.pageInfo.withdrawAmmount
            let detailLabel = UILabel(title: text, font: .systemFont(ofSize: 15), textColor: .gray, textAlignment: .right)
            self.withdrawAmountLabel = detailLabel

            hStack.addSubview(titleLabel)
            hStack.addSubview(detailLabel)
            titleLabel.snp.makeConstraints { make in
                make.left.top.centerY.equalToSuperview()
            }
            detailLabel.snp.makeConstraints { make in
                make.right.top.centerY.equalToSuperview()
            }
            return hStack
        case 2:
            let hStack = UIView()
            
            let titleLabel = UILabel(title: "到账银行卡", font: .systemFont(ofSize: 15), textColor: .C_wx_tip_text, textAlignment: .left)
            
            let text = self.pageInfo.bankCard.bank.title + " 尾号 " + self.pageInfo.bankCard.cardNumber
            let detailLabel = UILabel(title: text, font: .systemFont(ofSize: 15), textColor: .gray, textAlignment: .right)
            self.bankInfoLabel = detailLabel
            
            hStack.addSubview(titleLabel)
            hStack.addSubview(detailLabel)
            titleLabel.snp.makeConstraints { make in
                make.left.top.centerY.equalToSuperview()
            }
            detailLabel.snp.makeConstraints { make in
                make.right.top.centerY.equalToSuperview()
            }
            
            return hStack
        case 3:
            let hStack = UIView()
            
            let titleLabel = UILabel(title: "服务费", font: .systemFont(ofSize: 15), textColor: .C_wx_tip_text, textAlignment: .left)
            
            let feeFloat = (max(self.pageInfo.fee.floatValue, 0.1))
            let text = "¥" + String(format: "%.2f", feeFloat)
            let detailLabel = UILabel(title: text, font: .systemFont(ofSize: 15), textColor: .gray, textAlignment: .right)
            self.feeLabel = detailLabel
            
            hStack.addSubview(titleLabel)
            hStack.addSubview(detailLabel)
            titleLabel.snp.makeConstraints { make in
                make.left.top.centerY.equalToSuperview()
            }
            detailLabel.snp.makeConstraints { make in
                make.right.top.centerY.equalToSuperview()
            }
            
            return hStack
        default:
            return .init()
        }
    }
    
    func createHeaderView() -> UIView {
        let headerView = UIView.init()
        
        let vStack = VStack()
        vStack.alignment = .leading
        vStack.distribution = .equalSpacing
        // step1
        let step1 = createStepView(step: 1)
        
        // step2
        let step2 = createStepView(step: 2)
        
        // step3
        let step3 = createStepView(step: 3)
        
        vStack.addArrangedSubview(step1)
        vStack.addArrangedSubview(step2)
        vStack.addArrangedSubview(step3)
        
        let contentBox = vStack.boxView(left: 40)
        headerView.addSubview(contentBox)
        contentBox.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // config
        headerView.addTap {[weak self] sender in
            guard let self = self else { return }
            self.gotoEdit()
        }

        return headerView
    }
    
    /// 创建头部的第几步骤的view
    /// - Returns: view
    /// - Parameter step: 第几步骤 1 发起 / 2 处理中 / 3 到账成功
    func createStepView(step: Int) -> UIView {
        let titleFont = UIFont.systemFont(ofSize: 18)
        let imageWidht: CGFloat = 35
        let stepHeight: CGFloat = 60
        
        switch step {
        case 1:
            let hStack = HStack(spacing: 20)
            hStack.alignment = .top
            let top = DashLineView(color: .C_wx_green, direction: .top)
            top.snp.makeConstraints { make in
                make.height.equalTo(stepHeight)
                make.width.equalTo(imageWidht)
            }
            
            let label1 = UILabel(title: "发起提现申请", font: titleFont, textColor: .C_wx_tip_text, textAlignment: .left)
            
            hStack.addArrangedSubview(top)
            hStack.addArrangedSubview(label1)
            return hStack
        case 2:
            let hStack = HStack(spacing: 20)
            hStack.alignment = .center
            let image = UIImageView(named: "icon-wait")
            image.snp.makeConstraints { make in
                make.width.height.equalTo(imageWidht)
            }
            
            let vStack = VStack(spacing: 2)
            vStack.alignment = .leading
            let label1 = UILabel(title: "银行处理中", font: titleFont, textColor: .black, textAlignment: .left)
            let label2 = UILabel(title: "预计 \(Date().string(withFormatter: "MM-dd HH:mm")) 前到账", font: .systemFont(ofSize: 15), textColor: .C_wx_tip_text, textAlignment: .left)
            self.doneTimeLabel = label2
            vStack.addArrangedSubview(label1)
            vStack.addArrangedSubview(label2)
            
            hStack.addArrangedSubview(image)
            hStack.addArrangedSubview(vStack)
            return hStack
        case 3:
            let hStack = HStack(spacing: 20)
            hStack.alignment = .bottom
            let top = DashLineView(color: .C_wx_navbar_viewbgColor, direction: .bototom)
            top.snp.makeConstraints { make in
                make.height.equalTo(stepHeight)
                make.width.equalTo(imageWidht)
            }
            
            let label1 = UILabel(title: "到账成功", font: titleFont, textColor: .C_wx_tip_text, textAlignment: .left)
            
            hStack.addArrangedSubview(top)
            hStack.addArrangedSubview(label1)
            return hStack
        default:
            return .init()
        }
    }
    
}

extension WithdrawInprogressViewController {
    func gotoEdit() {
        let items: [EditItem] = [
            .init(title: "银行卡", key: "1", value: pageInfo.bankCard.bank.title),
            .init(title: "银行卡尾号", key: "2", value: pageInfo.bankCard.cardNumber),
            .init(title: "提现金额", key: "3", value: pageInfo.withdrawAmmount),
            .init(title: "服务费", key: "4", value: pageInfo.fee),
            .init(title: "到账时间", key: "5", value: pageInfo.doneTime)
        ]
        self.pushEditVC(items) {[weak self] params in
            guard let self = self else {return}
            
            self.pageInfo.bankCard.bank.title = params["1"] as? String ?? ""
            self.pageInfo.bankCard.cardNumber = params["2"] as? String ?? ""
            self.pageInfo.withdrawAmmount = params["3"] as? String ?? ""
            self.pageInfo.fee = params["4"] as? String ?? ""
            self.pageInfo.doneTime = params["5"] as? String ?? ""
            
            self.updatePageInfo()
        }

    }
}

extension WithdrawInprogressViewController {
    
    struct PageInfo {
        /// 到账卡片信息
        var bankCard: BankTool.BankCard
        /// 提现金额
        var withdrawAmmount: String
        /// 服务费
        var fee: String
        /// 到账时间
        var doneTime: String
    }
    
    func loadData() {
        // refreshUI
    }
    
}

extension WithdrawInprogressViewController {
    
    class DashLineView: UIView {
        enum Direction {
            case top, bototom
        }
        
        let color: UIColor
        let direction: Direction
        init(color: UIColor, direction: Direction) {
            self.color = color
            self.direction = direction
            super.init(frame: .zero)
            backgroundColor = .clear
            
            let dot = UIView()
            addSubview(dot)
            dot.backgroundColor = color
            dot.corner(radius: 9)
            dot.snp.makeConstraints { make in
                make.width.height.equalTo(18)
                if direction == .top {
                    make.top.equalTo(5)
                    make.centerX.equalToSuperview()
                }else{
                    make.bottom.equalTo(-5)
                    make.centerX.equalToSuperview()
                }
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func draw(_ rect: CGRect) {
            let lineColor = color
            let lineWidth: CGFloat = .line * 2
            let lineDashPattern: [NSNumber] = [3, 1]
            let lineDashPhase: CGFloat = 0.0
            
            let bezierPath = UIBezierPath()
            bezierPath.lineWidth = lineWidth
            switch direction {
            case .top:
                bezierPath.move(to: CGPoint(x: rect.midX, y: 10))
                bezierPath.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            default:
                bezierPath.move(to: CGPoint(x: rect.midX, y: rect.maxY-10))
                bezierPath.addLine(to: CGPoint(x: rect.midX, y: 0))
            }
            UIColor.clear.setStroke()
            bezierPath.stroke()
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = bezierPath.cgPath
            shapeLayer.strokeColor = lineColor.cgColor
            shapeLayer.fillColor = UIColor.yellow.cgColor
            shapeLayer.lineWidth = lineWidth
            shapeLayer.lineDashPattern = lineDashPattern as [NSNumber]
            shapeLayer.lineDashPhase = lineDashPhase
            
            layer.addSublayer(shapeLayer)
        }
    }
}



