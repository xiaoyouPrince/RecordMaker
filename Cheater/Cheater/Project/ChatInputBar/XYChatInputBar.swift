//
//  XYChatInputBar.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/6/12.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

import UIKit
import XYUIKit

/// 使用此协议为了屏蔽细节,解耦
public protocol ChatInputViewReferenceAble: AnyObject {
    var content: String { get }
}

public protocol ChatInputViewCallBackProtocal: AnyObject {
    
    /// 键盘将要弹出 - optional
    /// - Parameter noti: 系统弹键盘通知
    func keyboardWillShow(_ noti: Notification)
    
    /// 键盘将要收起 - optional
    /// - Parameter noti: 系统收键盘通知
    func keyboardWillHide(_ noti: Notification)
    
    /// 键盘发送按钮点击
    /// - Parameter text: 当前输入框文本
    /// - Parameter referenceMsg: 被引用的消息和内容
    func sendBtnClick(text: String, referenceMsg: ChatInputViewReferenceAble?)
    
    /// 点击发送按钮之后是否收起键盘
    /// - Returns: 返回值是否收起键盘  true 收起 / false 不收起 - 默认不收起键盘
    func shouldHideKeyboardWhenSendClick() -> Bool
    
    /// 语音状态下,点击长按说话按钮事件
    func holdSpeakBtnClick()
    
    /// 点击更多面板事件的回调
    /// - Parameter actionName: 时间名称,如 拍照/红包
    func functionAction(actionName: String)
}

extension ChatInputViewCallBackProtocal {
    func keyboardWillShow(_ noti: Notification){ }
    func keyboardWillHide(_ noti: Notification){ }
    func shouldHideKeyboardWhenSendClick() -> Bool { false }
    func functionAction(actionName: String){ }
}

/*
 此类使用 autolayout, 高度根据内容自适应, 外部布局时候不要设置高度约束
 整体布局如下:
 
 inputView -> contentView -> inputBar
 inputView -> emotionPad
 inputView -> functionPad
 */
public class ChatInputView: UIView {
    private var contentView = UIView()
    private var inputBar = ChatInputBar()
    weak var referenceMsg: ChatInputViewReferenceAble? { didSet{ inputBar.reference = referenceMsg } }
    
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
            make.edges.equalToSuperview()
        }
        
        inputBar.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-CGFloat.safeBottom)
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
    
    /// 保存一下 keyBoard 高度, 内部使用
    static var keyBoardHeight: CGFloat = 0
    /// 保存一下 keyBoard 弹出收起动画时间, 内部使用, 默认值 0.25, 根据键盘弹出真实赋值
    static var keyBoardAnimationTimeinterval: CGFloat = 0.25
    
    // MARK: - 共有有属性，可外部使用
    
    /// 默认自适应高度最大值，当输入内容自适应高度大于此值，不再变高，输入内容变为可滚动
    var maxHeight: CGFloat = 100
    /// 当前状态
    var state: BarState = .initinal
    /// 输入框草稿
    var draft: String = ""
    
    var reference: ChatInputViewReferenceAble? { didSet{ setupBottomView() } }
    var deledate: ChatInputViewCallBackProtocal?
    
    lazy var voiceBtn: UIButton = createBtn(named: "wechat_input_voice")
    lazy var emotionBtn: UIButton = createBtn(named: "wechat_input_emoticon")
    lazy var addBtn: UIButton = createBtn(named: "wechat_input_more")
    lazy var textView: UITextView = createTextView()
    lazy var holdSpeakBtn = createHoldSpeakBtn()
    lazy var bottomBoxView = UIView()
    private var emotionPad: UIView?
    private var functionPad: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = WXConfig.inputBgColor
        
        setupSubviews()
        addKeyNotification()
        addBtnActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 自定义底部容器,设置引用视图
    func setupBottomView() {
        let label = UILabel(title: reference?.content, font: .systemFont(ofSize: 13), textColor: .C_wx_tip_text, textAlignment: .left)
        bottomBoxView.addSubview(label)
        label.backgroundColor = .white.withAlphaComponent(0.5)
        label.corner(radius: 5)
        label.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(40)
            make.bottom.equalTo(-3)
        }
        
        label.addTap {[weak self] sender in
            guard let self = self else { return }
            sender.removeFromSuperview()
            self.updatePadViewsLayout()
        }
        
        updatePadViewsLayout()
    }
}


extension ChatInputBar {
    
    enum BarState: Int {
        /// 初始状态, 初始化时候的状态, 即键盘未弹出时候的状态
        case initinal
        /// 键盘弹出且在输入时候到状态, 此时可能已经有输入,或者没有输入,此状态可能发生 布局 修改
        case keyboard
        /// 语音按钮点击后状态,输出语音状态
        case voice
        
        case emotion
        
        case add
    }
    
    /// 子视图 tag
    struct ViewTag {
        static let emotionPad: Int = 10001
        static let morePad: Int = 10002
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
            keyBoardSendBtnClick()
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
    
    /// textView 内部内容改动时候适配高度
    /// - Parameter textView: 调整的 textView，即内部 textView
    func adjustSelfFrame(with textView: UITextView){
        
        if textView.text.isEmpty == false {
            state = .keyboard
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
            }else{
                textView.snp.updateConstraints { make in
                    make.height.equalTo(contentSize.height)
                }
            }
        } else { // 增高
            targetHeight = min(targetHeight, maxHeight)
            textView.snp.updateConstraints { make in
                make.height.equalTo(targetHeight)
            }
        }
    }
}

// MARK: - 键盘通知

extension ChatInputBar {
    
    func addKeyNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIView.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIView.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ noti: Notification){
        if !textView.isFirstResponder {return}
        
        // print(noti)
        deledate?.keyboardWillShow(noti)
        guard let userInfo = noti.userInfo as? [String: Any],
              let kbEndFrame = userInfo["UIKeyboardFrameEndUserInfoKey"] as? CGRect,
              let time = userInfo["UIKeyboardAnimationDurationUserInfoKey"] as? TimeInterval else {
            return
        }
        
        let keyboardHeight = kbEndFrame.height
        ChatInputBar.keyBoardHeight = keyboardHeight
        ChatInputBar.keyBoardAnimationTimeinterval = time
        
        if state == .initinal {
            UIView.animate(withDuration: time) {
                self.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(-keyboardHeight)
                }
                self.viewController?.view.layoutIfNeeded()
            }
        } else
        if state == .keyboard {
            UIView.animate(withDuration: self.keyBoardTime, delay: 0) {
                self.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(-self.keyBoardHeight)
                }
                self.viewController?.view.layoutIfNeeded()
            }
        } else { // voice / emotion / add
            removeEmotionPad()
            removeMorePad()
            setUIforKeyboad()
        }
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
            UIView.animate(withDuration: time) {
                self.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(-CGFloat.safeBottom)
                }
                self.viewController?.view.layoutIfNeeded()
            }
        }else
        if state == .keyboard {
            if let contentView = self.superview?.superview {
                UIView.animate(withDuration: time, delay: 0) {
                    contentView.snp.updateConstraints { make in
                        make.height.equalTo(self.textView.bounds.height + self.bottomBoxView.bounds.height + CGFloat.safeBottom)
                    }
                    self.viewController?.view.layoutIfNeeded()
                }
            }
        }
        
    }
}

// MARK: - ButtonActions

extension ChatInputBar {
    
    private func addBtnActions() {
        
        voiceBtn.addTap {[weak self] sender in
            guard let self = self else { return }
            if self.state == .keyboard || self.state == .initinal { // 当前是键盘输入状态, 记录草稿, 修改为语音状态
                self.setUIforVoice()
            } else
            if self.state == .voice { // 当前语音状态, 修改为 keyboard 状态,有草稿就恢复一下
                self.setUIforKeyboad()
            }
            else
            if self.state == .emotion || self.state == .add { // 当前弹框,直接修改为语音状态
                self.setUIforVoice()
            }
        }
        
        holdSpeakBtn.addTap { [weak self] sender in
            guard let self = self else { return }
            
            // Toast.make(sender.currentTitle ?? "")
            
            /*
             * - TODO -
             * 添加语音输入功能,添加语音类型的消息.
             * 传出去,让代理做具体事情
             *  1. 单聊
             *  2. 群聊
             */
            
            self.deledate?.holdSpeakBtnClick()
        }
        
        emotionBtn.addTap { [weak self] sender in
            guard let self = self else { return }
        
            if self.state == .emotion { // change to keyboard
                self.state = .keyboard
                self.removeEmotionPad()
                self.setUIforKeyboad()
                return;
            }
            
            self.state = .emotion
            self.holdSpeakBtn.isHidden = true
            self.textView.resignFirstResponder()
            self.emotionBtn.setImage(UIImage(named: "wechat_input_keyboard")?.withRenderingMode(.alwaysOriginal), for: .normal)
            
            self.removeMorePad()
            
            let emotionHeight: CGFloat = 600
            let emotionPad = UIView()
            emotionPad.tag = ViewTag.emotionPad
            emotionPad.backgroundColor = .red.withAlphaComponent(0.5)
            self.emotionPad = emotionPad
            
            if let contentView = self.superview?.superview { // inputView
                contentView.addSubview(emotionPad)
                emotionPad.frame = .init(origin: .init(x: 0, y: self.bounds.height), size: .init(width: .width, height: emotionHeight))
                
                UIView.animate(withDuration: self.keyBoardTime, delay: 0) {
                    self.snp.updateConstraints { make in
                        make.bottom.equalToSuperview().offset(-emotionHeight)
                    }
                    self.viewController?.view.layoutIfNeeded()
                }
            }
        }
        
        addBtn.addTap { [weak self] sender in
            guard let self = self else { return }
            
            if self.state == .add { // change to keyboard
                self.state = .keyboard
                self.removeMorePad()
                self.setUIforKeyboad()
                return;
            }
            
            self.state = .add
            self.holdSpeakBtn.isHidden = true
            self.textView.resignFirstResponder()
            self.setVoiceAndEmotionBtnInitinal()
            
            self.removeEmotionPad()
            
            
            // create function pad & animation to right position
            let functionHeight: CGFloat = 260
            var functionPad: UIView! = self.functionPad
            if functionPad == nil {
                let Pad = XYChatInputFunctionPad(frame: .zero)
                Pad.actionCallback = { [weak self] title in
                    self?.deledate?.functionAction(actionName: title)
                }
                functionPad = Pad
            }
            self.functionPad = functionPad
            functionPad.tag = ViewTag.morePad
            
            if let contentView = self.superview?.superview { // inputView
                contentView.addSubview(functionPad)
                functionPad.frame = .init(origin: .init(x: 0, y: self.bounds.height), size: .init(width: .width, height: functionHeight))
                
                UIView.animate(withDuration: self.keyBoardTime, delay: 0) {
                    self.snp.updateConstraints { make in
                        make.bottom.equalToSuperview().offset(-functionHeight)
                    }
                    self.viewController?.view.layoutIfNeeded()
                }
            }
            
        }
    }
    
    /// 键盘上 return 按钮点击
    private func keyBoardSendBtnClick(){
        let text = textView.text ?? ""
        deledate?.sendBtnClick(text: text, referenceMsg: nil)
        textView.text = ""
        textViewDidChange(textView)
        
        let shouldHideKeyboard = deledate?.shouldHideKeyboardWhenSendClick() ?? false
        if shouldHideKeyboard { // 收起键盘的操作
            textView.resignFirstResponder()
        }// 不收起键盘的操作
    }
}

// MARK: - UI

extension ChatInputBar {
    
    private func setupSubviews() {
        addSubview(voiceBtn)
        addSubview(textView)
        addSubview(emotionBtn)
        addSubview(addBtn)
        addSubview(holdSpeakBtn)
        addSubview(bottomBoxView)
        
        voiceBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-7)
        }
        
        textView.snp.makeConstraints { make in
            make.left.equalTo(voiceBtn.snp.right).offset(5)
            make.top.equalToSuperview().offset(7)
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
        
        holdSpeakBtn.isHidden = true
        holdSpeakBtn.snp.makeConstraints { make in
            make.edges.equalTo(textView)
        }
        
        bottomBoxView.snp.makeConstraints { make in
            make.left.width.equalTo(textView)
            make.top.equalTo(textView.snp.bottom).offset(3)
        }
        
        self.snp.makeConstraints { make in
            make.bottom.equalTo(bottomBoxView).offset(4)
        }
        
        // top line
        addSubview(.line)
    }
    
    /// 更新表情框和功能框布局
    private func updatePadViewsLayout() {
        setNeedsLayout()
        layoutIfNeeded()
        
        let orgin: CGPoint = .init(x: 0, y: self.bounds.height)
        emotionPad?.frame.origin = orgin
        functionPad?.frame.origin = orgin
    }
    
    private func createTextView() -> UITextView {
        let textView = UITextView()
        textView.delegate = self
        textView.backgroundColor = .white//UIColor.groupTableViewBackground
        textView.tintColor = WXConfig.wxGreen
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
    
    private func createHoldSpeakBtn() -> UIButton {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 15)
        btn.setTitle("按住 说话", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }
    
    var keyBoardHeight: CGFloat {
        ChatInputBar.keyBoardHeight
    }
    
    var keyBoardTime: TimeInterval {
        ChatInputBar.keyBoardAnimationTimeinterval
    }
    
    /// 移除 emotionPad
    private func removeEmotionPad() {
        guard let contentView = self.superview?.superview else { return } // ChatInputView
        
        contentView.findSubView { subview in
            if subview.tag == ViewTag.emotionPad {
                subview.removeFromSuperview()
                return true
            }
            return false
        }
    }
    
    /// 移除 addPad
    private func removeMorePad() {
        guard let contentView = self.superview?.superview else { return } // ChatInputView
        
        contentView.findSubView { subview in
            if subview.tag == ViewTag.morePad {
                subview.removeFromSuperview()
                return true
            }
            return false
        }
    }
    
    /// 保存草稿
    private func restoreDraft() {
        draft = textView.text
        textView.text = ""
    }
    
    /// 恢复草稿
    private func recoverDraft() {
        textView.text = draft
        textViewDidChange(textView)
    }
    
    private func setVoiceAndEmotionBtnInitinal() {
        voiceBtn.setImage(UIImage(named: "wechat_input_voice")?.withRenderingMode(.alwaysOriginal), for: .normal)
        holdSpeakBtn.isHidden = true
        
        emotionBtn.setImage(UIImage(named: "wechat_input_emoticon")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private func setUIforInitinal(){
        state = .initinal
        textView.resignFirstResponder()
        
        setVoiceAndEmotionBtnInitinal()
        
        if let contentView = self.superview?.superview {
            UIView.animate(withDuration: keyBoardTime, delay: 0) {
                contentView.snp.updateConstraints { make in
                    make.height.equalTo(CGFloat.tabBar + self.bottomBoxView.bounds.height)
                }
                self.viewController?.view.layoutIfNeeded()
            }
        }
    }
    
    private func setUIforKeyboad(){
        state = .keyboard
        // 应该先弹出键盘,否则动画期间恢复草稿
        recoverDraft()
        textView.becomeFirstResponder()
        
        setVoiceAndEmotionBtnInitinal()
        
        UIView.animate(withDuration: keyBoardTime, delay: 0) {
            self.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-self.keyBoardHeight)
            }
            self.viewController?.view.layoutIfNeeded()
        }
        
    }
    
    private func setUIforVoice(){
        state = .voice
        textView.resignFirstResponder()
        removeEmotionPad()
        removeMorePad()
        
        voiceBtn.setImage(UIImage(named: "wechat_input_keyboard")?.withRenderingMode(.alwaysOriginal), for: .normal)
        holdSpeakBtn.isHidden = false
        
        emotionBtn.setImage(UIImage(named: "wechat_input_emoticon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        restoreDraft()
        
        self.textView.snp.updateConstraints { make in
            make.height.equalTo(35)
        }
        
        UIView.animate(withDuration: keyBoardTime) {
            self.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-CGFloat.safeBottom)
            }
            self.viewController?.view.layoutIfNeeded()
        }
    }
    
}



