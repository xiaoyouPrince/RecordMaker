//
//  XYChatInputBar.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/6/12.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit
import XYUIKit

public protocol ChatInputViewCallBackProtocal: AnyObject {
    
    /// 键盘将要弹出 - optional
    /// - Parameter noti: 系统弹键盘通知
    func keyboardWillShow(_ noti: Notification)
    
    /// 键盘将要收起 - optional
    /// - Parameter noti: 系统收键盘通知
    func keyboardWillHide(_ noti: Notification)
    
    /// 键盘发送按钮点击
    /// - Parameter text: 当前输入框文本
    func sendBtnClick(text: String)
    
    /// 点击发送按钮之后是否收起键盘
    /// - Returns: 返回值是否收起键盘  true 收起 / false 不收起 - 默认不收起键盘
    func shouldHideKeyboardWhenSendClick() -> Bool
    
}

extension ChatInputViewCallBackProtocal {
    func keyboardWillShow(_ noti: Notification){ }
    func keyboardWillHide(_ noti: Notification){ }
    func shouldHideKeyboardWhenSendClick() -> Bool { false }
}


public class ChatInputView: UIView {
    private var contentView = UIView()
    private var inputBar = ChatInputBar()
    
    weak var deledate: ChatInputViewCallBackProtocal? {
        didSet{
            inputBar.deledate = deledate
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(contentView)
        contentView.addSubview(inputBar)
        contentView.backgroundColor = WXConfig.inputBgColor
        
        contentView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
            make.height.equalTo(CGFloat.tabBar)
        }
        
        inputBar.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    public override func resignFirstResponder() -> Bool {
        inputBar.textView.resignFirstResponder()
        return super.resignFirstResponder()
    }
    
}

/// 类会自适应高度，无需设置高度
/// 初始默认高度 56，默认会设置 frame 为 screen 宽度
private class ChatInputBar: UIView {
    
    /// 保存一下 keyBoard 整理高度, 内部使用
    static var keyBoardHeight: CGFloat = 0
    
    // MARK: - 共有有属性，可外部使用
    
    /// 默认自适应高度最大值，当输入内容自适应高度大于此值，不再变高，输入内容变为可滚动
    var maxHeight: CGFloat = 100
    
    /// 当前状态
    var state: BarState = .initinal
    
    var deledate: ChatInputViewCallBackProtocal?
    
    lazy var voiceBtn: UIButton = createBtn(named: "wechat_input_voice")
    lazy var emotionBtn: UIButton = createBtn(named: "wechat_input_emoticon")
    lazy var addBtn: UIButton = createBtn(named: "wechat_input_more")
    lazy var textView: UITextView = createTextView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = WXConfig.inputBgColor
        
        setupSubviews()
        addKeyNotification()
        
        addBtn.addTap {[weak self] sender in
            self?.textView.resignFirstResponder()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// textView 内部内容改动时候适配高度
    /// - Parameter textView: 调整的 textView，即内部 textView
    func adjustSelfFrame(with textView: UITextView){
        
        if textView.text.isEmpty == false {
            state = .hasInput
        }else{
            state = .initinal
        }
        
        let contentSize = textView.contentSize
        let currentHeight = textView.bounds.size.height
        var targetHeight = currentHeight + textView.contentOffset.y
        
        
        if currentHeight > contentSize.height { // 需要减少了
            if (contentSize.height - 35) < 5 { // 取巧,比初始值大一点,按初始值算
                textView.snp.updateConstraints { make in
                    make.height.equalTo(35)
                }
                
                if let inputVie = superview?.superview {
                    inputVie.snp.updateConstraints { make in
                        make.height.equalTo(CGFloat.tabBar - CGFloat.safeBottom + ChatInputBar.keyBoardHeight)
                    }
                }
            }else{
                textView.snp.updateConstraints { make in
                    make.height.equalTo(contentSize.height)
                }
                
                if let inputVie = superview?.superview {
                    inputVie.snp.updateConstraints { make in
                        make.height.equalTo(contentSize.height + 14 + ChatInputBar.keyBoardHeight)
                    }
                }
            }
        } else { // 增高
            
            targetHeight = min(targetHeight, maxHeight)
            textView.snp.updateConstraints { make in
                make.height.equalTo(targetHeight)
            }
            
            if let inputVie = superview?.superview {
                inputVie.snp.updateConstraints { make in
                    make.height.equalTo(targetHeight - textView.bounds.height + inputVie.bounds.height)
                }
            }
        }
    }
    
    /// 调整内部 view 的 frame，当 self.frame 发生改变时调用
    /// - Parameter except: 指定不需调整的View，默认是内部 textView
    func adjustSubViewsFrame(_ except: UIView) {
        return;
        for subView in self.subviews {
            if subView == except {
                continue
            }else{
                let vInset = (self.bounds.height - self.textView.bounds.height) / 2
                subView.frame = CGRect(x: subView.frame.origin.x, y: self.bounds.height - subView.frame.size.height - vInset, width: subView.frame.size.width, height: subView.frame.size.height)
            }
        }
    }
}


extension ChatInputBar {
    
    enum BarState: Int {
        /// 初始状态, 初始化时候的状态
        case initinal
        /// 已经有文本输入之后的状态,此状态可能发生 布局 修改
        case hasInput
        
        case voice
        
        case input
        
        case emotion
        
        case add
    }
}

// MARK: - UITextViewDelegate

extension ChatInputBar: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        adjustSelfFrame(with: textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            // 用户点击了 Return 按钮
            sendBtnClick()
            // 返回 false 可以阻止 UITextView 插入换行符
            return false
        }
        
        if text == "" {
            // 用户点击了 back 按钮
            return true
        }
        
        // 返回 true 以允许 UITextView 插入文本
        return true
    }
    
    
}

// MARK: - 键盘通知

extension ChatInputBar {
    
    func addKeyNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIView.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIView.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ noti: Notification){
        // print(noti)
        deledate?.keyboardWillShow(noti)
        guard let userInfo = noti.userInfo as? [String: Any],
              let kbEndFrame = userInfo["UIKeyboardFrameEndUserInfoKey"] as? CGRect,
              let time = userInfo["UIKeyboardAnimationDurationUserInfoKey"] as? TimeInterval else {
            return
        }
        
        let keyboardHeight = kbEndFrame.height
        ChatInputBar.keyBoardHeight = keyboardHeight
        
        if state == .initinal {
            if let contentView = self.superview?.superview {
                UIView.animate(withDuration: time, delay: 0) {
                    contentView.snp.updateConstraints { make in
                        make.height.equalTo(keyboardHeight + CGFloat.tabBar - CGFloat.safeBottom)
                    }
                    self.viewController?.view.layoutIfNeeded()
                }
            }
        } else
        if state == .hasInput {
            if let contentView = self.superview?.superview {
                UIView.animate(withDuration: time, delay: 0) {
                    contentView.snp.updateConstraints { make in
                        make.height.equalTo(keyboardHeight + self.bounds.height)
                    }
                    self.viewController?.view.layoutIfNeeded()
                }
            }
        }
        
        setTextViewCurser()
    }
    
    @objc func keyboardWillHide(_ noti: Notification){
        deledate?.keyboardWillHide(noti)
        //print(noti)
        
        guard let userInfo = noti.userInfo as? [String: Any],
              let _ = userInfo["UIKeyboardFrameEndUserInfoKey"] as? CGRect,
              let time = userInfo["UIKeyboardAnimationDurationUserInfoKey"] as? TimeInterval else {
            return
        }
        
        if state == .initinal {
            if let contentView = self.superview?.superview {
                UIView.animate(withDuration: time, delay: 0) {
                    contentView.snp.updateConstraints { make in
                        make.height.equalTo(CGFloat.tabBar)
                    }
                    self.viewController?.view.layoutIfNeeded()
                }
            }
        }else
        if state == .hasInput {
            if let contentView = self.superview?.superview {
                UIView.animate(withDuration: time, delay: 0) {
                    contentView.snp.updateConstraints { make in
                        make.height.equalTo(self.textView.bounds.height + CGFloat.safeBottom)
                    }
                    self.viewController?.view.layoutIfNeeded()
                }
            }
        }
        
    }
}

// MARK: - UI

extension ChatInputBar {
    
    private func setupSubviews() {
        addSubview(voiceBtn)
        addSubview(textView)
        addSubview(emotionBtn)
        addSubview(addBtn)
        
        voiceBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-7)
        }
        
        textView.snp.makeConstraints { make in
            make.left.equalTo(voiceBtn.snp.right).offset(5)
            make.bottom.equalToSuperview().offset(-7)
            make.height.equalTo(35)
        }
        
        emotionBtn.snp.makeConstraints { make in
            make.left.equalTo(textView.snp.right).offset(5)
            make.bottom.equalToSuperview().offset(-7)
        }
        
        addBtn.snp.makeConstraints { make in
            make.left.equalTo(emotionBtn.snp.right).offset(5)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-7)
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(textView).offset(14)
        }
        
        // top line
        addSubview(.line)
    }
    
    private func createTextView() -> UITextView {
        let textView = UITextView()
        textView.delegate = self
        textView.backgroundColor = .white//UIColor.groupTableViewBackground
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textContainerInset = UIEdgeInsets(top: 9, left: 16, bottom: 9, right: 16)
        textView.returnKeyType = .send
        textView.enablesReturnKeyAutomatically = true
        textView.corner(radius: 5)
        return textView
    }
    
    private func createBtn(named: String) -> UIButton {
        createBtn(image: UIImage(named: named) ?? .init())
    }
    
    private func createBtn(image: UIImage) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.snp.makeConstraints { make in
            make.width.height.equalTo(CGSize.init(width: 35, height: 35))
        }
        return btn
    }
    
    /// 设置 textView 的光标颜色 -  需要有光标的时候才能设置
    private func setTextViewCurser(){
        textView.findSubViewRecursion { subview in
            if subview.bounds.width == 2 {
                subview.backgroundColor = WXConfig.wxGreen
                return true
            }
            
            return false
        }
    }
    
    
    @objc func sendBtnClick(){
        let text = textView.text ?? ""
        deledate?.sendBtnClick(text: text)
        textView.text = ""
        textViewDidChange(textView)
        
        let shouldHideKeyboard = deledate?.shouldHideKeyboardWhenSendClick() ?? false
        if shouldHideKeyboard { // 收起键盘的操作
            textView.resignFirstResponder()
        }// 不收起键盘的操作
    }
}



