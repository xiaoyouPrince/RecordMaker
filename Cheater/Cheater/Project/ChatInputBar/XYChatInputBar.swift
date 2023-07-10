//
//  XYChatInputBar.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/6/12.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit
import XYUIKit

public class ChatInputView: UIView {
    private var contentView = UIView()
    private var inputBar = ChatInputBar()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(contentView)
        contentView.addSubview(inputBar)
        
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
    
    static var keyBoardHeight: CGFloat = 0
    
    // MARK: - 共有有属性，可外部使用
    /// 默认自适应高度最大值，当输入内容自适应高度大于此值，不再变高，输入内容变为可滚动
    var maxHeight: CGFloat = 100
    
    var state: BarState = .initinal
    
    lazy var voiceBtn: UIButton = createBtn(named: "wechat_input_voice")
    lazy var emotionBtn: UIButton = createBtn(named: "wechat_input_emoticon")
    lazy var addBtn: UIButton = createBtn(named: "wechat_input_more")
    lazy var textView: UITextView = createTextView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = WXConfig.wxGreen
        
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

// MARK: - UITextViewDelegate

extension ChatInputBar: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        adjustSelfFrame(with: textView)
    }
}

// MARK: - 键盘通知

extension ChatInputBar {
    
    func addKeyNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIView.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIView.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ noti: Notification){
        print(noti)
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
        
        
    }
    
    @objc func keyboardWillHide(_ noti: Notification){
        print(noti)
        
        guard let userInfo = noti.userInfo as? [String: Any],
              let kbEndFrame = userInfo["UIKeyboardFrameEndUserInfoKey"] as? CGRect,
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
    }
    
    private func createTextView() -> UITextView {
        let textView = UITextView()
        textView.delegate = self
        textView.backgroundColor = .red//UIColor.groupTableViewBackground
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textContainerInset = UIEdgeInsets(top: 9, left: 16, bottom: 9, right: 16)
        textView.returnKeyType = .send
        return textView
    }
    
    private func createBtn(named: String) -> UIButton {
        createBtn(image: UIImage(named: named) ?? .init())
    }
    
    private func createBtn(image: UIImage) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setImage(image, for: .normal)
        btn.snp.makeConstraints { make in
            make.width.height.equalTo(CGSize.init(width: 35, height: 35))
        }
        return btn
    }
    
    
    @objc func sendBtnClick(){
        
        if textView.inputView == nil {
            
            textView.resignFirstResponder()
            let inputView = UIView()
            inputView.backgroundColor = .green
            inputView.frame = CGRect(x: 0, y: 0, width: 300, height: 600)
            
            textView.inputView = inputView
            //            textView.inputView = emotionVC.view
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.textView.becomeFirstResponder()
            }
        }else{
            textView.resignFirstResponder()
            textView.inputView = nil
            
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            //                self.textView.becomeFirstResponder()
            //            }
        }
        
    }
}



