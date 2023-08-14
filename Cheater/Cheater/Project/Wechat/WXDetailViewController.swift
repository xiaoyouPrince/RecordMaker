//
//  WXDetailViewController.swift
//  Cheater
//
//  Created by 渠晓友 on 2023/7/9.
//  Copyright © 2023 xiaoyou. All rights reserved.
//

/*
 * - TODO -
 * 微信聊天详情页面
 *
 *  1. UI -> (navBar + tableView + inputView)
 *  2. Data -> (暂时用文件, 后续使用数据库改造)
 */

import Foundation
import XYUIKit
import AudioToolbox

/// 微信消息有更新的协议
protocol WXMessageDidupdateProtocol: AnyObject {
    /// 最后一条消息有更新, 列表需要刷新, 内部做持久化操作
    func lastMessageDidupdate()
}


class WXDetailViewController: UIViewController {
    
    var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    var sessionInputView = ChatInputView()
    var lsitModel: WXListModel
    var dataArray: [WXDetailModel]
    /// 当前发送者id, 默认是自己,后续可以随时调整
    var currentSenderID: Int = WXUserInfo.shared.id
    weak var delegate: WXMessageDidupdateProtocol?
    
    init(listModel: WXListModel, delegate: WXMessageDidupdateProtocol) {
        self.lsitModel = listModel
        self.delegate = delegate
        /*
         * - TODO -
         * 进入详情的参数,目的是知道找哪个目标聊天记录的文件
         */
        guard let targetContact = listModel.targetContact else { fatalError("无目标对象,数据异常") }
        DataSource_wxDetail.targetContact = targetContact
        self.dataArray = DataSource_wxDetail.allMessages ?? []
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.reloadData()
    }
    
    /// 持久化聊天记录详情
    func archiveChatDB() {
        DispatchQueue.global().async {
            XYFileManager.writeFile(with: DataSource_wxDetail.targetDB_filePath, models: self.dataArray)
        }
    }
    
    func tableViewScrollToBottom(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tableView.scrollToRow(at: IndexPath.init(row: self.dataArray.count-1, section: 0), at: .bottom, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        archiveChatDB()
        
        tableViewScrollToBottom()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // update msg list
        
        // update file archive
        archiveChatDB()
    }
    
    func setupUI() {
        view.backgroundColor = WXConfig.navBarBgColor
        
        setupNav()
        setupTableView()
        setupSessionInputView()
        layoutSubviews()
    }
    
    func setupNav() {
        setNavbarWechat()
        nav_setCustom(backImage: WXConfig.wx_backImag)
        
        // right
        navigationItem.rightBarButtonItem = .xy_item(withTarget: self, action: #selector(rightBtnClick), image: .wx_right_3dot, imageEdgeInsets: .init(top: 0, left: 0, bottom: 0, right: -20))
        
        // titleView + aciton
        let titleViewCoverView = UIView(frame: .init(origin: .init(x: 100, y: 0), size: CGSize(width: .width - 200, height: 44)))
        navigationController?.navigationBar .addSubview(titleViewCoverView)
        titleViewCoverView.backgroundColor = .red.withAlphaComponent(0.5)
        titleViewCoverView.addTap { [weak self] sender in
            guard let self = self else{ return }
            self.changeUser()
        }
    }
    
    func changeUser() {
        guard let target = DataSource_wxDetail.targetContact,let targetId = target.id else { return }
        let mineId = WXUserInfo.shared.id
        
        if self.currentSenderID == targetId {
            self.currentSenderID = mineId
            DataSource_wxDetail.currentSpeaker = WXContact.init(userInfo: WXUserInfo.shared)
            
            let userName = String(describing: WXUserInfo.shared.name ?? "")
            Toast.make("切换为 \"\(userName)\" 发言")
        } else
        {
            self.currentSenderID = targetId
            DataSource_wxDetail.currentSpeaker = WXContact.init(userInfo: target.userInfo)
            
            let userName = String(describing: target.userInfo.name ?? "")
            Toast.make("切换为 \"\(userName)\" 发言")
        }
        
        
        
        // 震动一下
        //AudioServicesPlaySystemSound(0)
        
        /*
         * - TODO -
         * 切换当前发言者 && 震动反馈
         * 如果是群聊,需要特殊处理,可以弹框手动选择发言人
         */
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WXDetailCell.self, forCellReuseIdentifier: WXDetailCell.indentifier)
        tableView.estimatedRowHeight = 20 + 8 + 8 //UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
    func setupSessionInputView() {
        view.addSubview(sessionInputView)
        sessionInputView.deledate = self
    }
    
    func layoutSubviews(){
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(sessionInputView.snp.top)
            make.height.equalTo(CGFloat.height - CGFloat.tabBar)
        }
        
        sessionInputView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            //make.height.equalTo(CGFloat.tabBar)
        }
    }
}

extension WXDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //sessionInputView.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: WXDetailCell.indentifier) as? WXDetailCell
        if cell == nil {
            cell = WXDetailCell.init(style: .default, reuseIdentifier: WXDetailCell.indentifier)
        }
        
        // cell config
        // ...
        cell?.delegate = self
        cell?.model = self.dataArray[indexPath.row]
        
        return cell!
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.scrollToRow(at: .init(row: dataArray.count - 1, section: 0), at: .bottom, animated: false)
    }
    
    
}

// MARK: - Cell Based Actions

extension WXDetailViewController: WXDetailCellDelegate {
    func deleteUserForMsg(_ model: WXDetailModel) {
        model.isUserBeingDeleted = true
        model.isUserBeingBlocked = true
        reloadTableAndArchiveDB()
    }
    
    func cancelDeleteUserForMsg(_ model: WXDetailModel) {
        model.isUserBeingDeleted = false
        model.isUserBeingBlocked = false
        reloadTableAndArchiveDB()
    }
    
    func blockUserForMsg(_ model: WXDetailModel) {
        model.isUserBeingBlocked = true
        model.isUserBeingDeleted = false
        reloadTableAndArchiveDB()
    }
    
    func cancelBlockUserForMsg(_ model: WXDetailModel) {
        model.isUserBeingBlocked = false
        reloadTableAndArchiveDB()
    }
    
    func copyTextForMsg(_ model: WXDetailModel) {
        if let text = model.getCopyText() {
            UIPasteboard.general.string = text
            Toast.make("复制完成")
        }
    }
    
    func editForMsg(_ model: WXDetailModel) {
        switch model.msgType {
        case .time:
            let editVC = SendTimeController()
            editVC.msgModel = model
            push(editVC, animated: true)
            break
        case .text:
            let editVC = EditTextViewController()
            editVC.msgModel = model
            push(editVC, animated: true)
            break
        case .voice:
            let editVC = SendAudioViewController()
            editVC.msgModel = model
            push(editVC, animated: true)
            break
        case .image:
            let editVC = EditImageViewController()
            editVC.msgModel = model
            push(editVC, animated: true)
            break
        case .video:
            let editVC = SendVideoController()
            editVC.msgModel = model
            push(editVC, animated: true)
            break
        case .voip:
            let editVC = SendVoipCpntroller()
            editVC.msgModel = model
            push(editVC, animated: true)
            break
        case .system:
            let editVC = SendSystemMsgController()
            editVC.msgModel = model
            push(editVC, animated: true)
            break
        case .red_packet:
            let editVC = EditRedPacketController()
            editVC.msgModel = model
            push(editVC, animated: true)
            break
        case .money_transfer:
            let editVC = EditMoneyTransferController()
            editVC.msgModel = model
            push(editVC, animated: true)
            break
        case .link:
            let editVC = SendLinkController()
            editVC.msgModel = model
            push(editVC, animated: true)
            break
        case .file:
            let editVC = SendFileController()
            editVC.msgModel = model
            push(editVC, animated: true)
            break
        case .idCard:
            let editVC = SendIDCardController()
            editVC.msgModel = model
            push(editVC, animated: true)
            break
        case .location:
            let editVC = SendLocationController()
            editVC.msgModel = model
            push(editVC, animated: true)
            break
        default:
            break
        }
    }
    
    func recallForMsg(_ model: WXDetailModel) {
        AlertController.showAlert(title: "🔔", message: "确认撤回吗", btnTitles: "取消", "确定", callback: { index in
            if index != 1 { return }
            
            let sModel = MsgSystemModel()
            sModel.content = "你撤回了一条消息"
            let recallModel = WXDetailModel(systemMsg: sModel)
            
            if let index = self.dataArray.firstIndex(of: model){
                self.dataArray[index] = recallModel
            }
            self.reloadTableAndArchiveDB()
        })
    }
    
    func changeSenderForMsg(_ model: WXDetailModel) {
        let meId = WXUserInfo.shared.id
        let targetId = DataSource_wxDetail.targetContact?.id
        if model.from == meId {
            model.from = targetId
        }else{
            model.from = meId
        }
        reloadTableAndArchiveDB()
    }
    
    func referenceMsg(_ model: WXDetailModel) {
        // 被引用消息,告知 inputView
        // inputView 点击发送的时候需要回传被引用的 model
        sessionInputView.referenceMsg = model
    }
    
    func deleteMsg(_ model: WXDetailModel) {
        deleteMsgModel(model)
    }
}


// MARK: - VC Based Actions

extension WXDetailViewController {
    
    @objc func leftBtnClick(){
        Toast.make("leftBtnClick")
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBtnClick(){
        Toast.make("rightBtnClick")
        
        /*
         * - TODO -
         * 随机生成一条文本消息,并放入UI
         * <#这里输入你要做的事情的一些思路#>
         *  <#1. ...#>
         *  <#2. ...#>
         */
        
        
        let titles = [
            "你好",
            "随机生成一条文本消息,并放入UI",
            "随机生成一条文本消息,并放入UI随机生成一条文本消息,并放入UI随机生成一条文本消息,并放入UI",
            "ZTC晋升申请表-202206月ZTC晋升申请表-202206月"
        ]
        
        let model = WXDetailModel.init(text: titles[Int(arc4random())%4])
        if (arc4random() % 2) == 0 {
            model.from = WXUserInfo.shared.id
        }
        //self.dataArray.append(model)
        dataArrayAppendMsg(model)
        XYFileManager.writeFile(with: DataSource_wxDetail.targetDB_filePath, models: self.dataArray)
        
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            self.tableView.scrollToRow(at: IndexPath.init(row: self.dataArray.count-1, section: 0), at: .bottom, animated: true)
        }
    }
}


// MARK: - 输入框的代理回调

extension WXDetailViewController: ChatInputViewCallBackProtocal {
    
    func holdSpeakBtnClick() {
        let voiceVC = SendAudioViewController()
        voiceVC.callback = {[weak self] voiceModel in
            guard let self = self else { return }
            
            // 创建新消息对象,写入内存,绘制UI,数据持久化
            let model = WXDetailModel(voice: voiceModel)
            model.from = self.currentSenderID
            
            // self.dataArray.append(model)
            // 写入文件的操作,在 view will appear 生命周期统一处理
            self.dataArrayAppendMsg(model)
            
            self.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                self.tableView.scrollToRow(at: IndexPath.init(row: self.dataArray.count-1, section: 0), at: .bottom, animated: true)
            }
            
            // 更新消息列表最后一句话和时间
            self.lsitModel.time = Date().timeIntervalSince1970
            self.lsitModel.lsatMessage = "[语音]"
            self.lsitModel.updateListMemory()
            self.delegate?.lastMessageDidupdate()
        }
        push(voiceVC, animated: true)
    }
    
    func sendBtnClick(text: String, referenceMsg: ChatInputViewReferenceAble?) {
        sendBtnClick(text: text, referenceMsg: referenceMsg as? WXDetailModel)
    }
    func sendBtnClick(text: String, referenceMsg: WXDetailModel?) {
        // Toast.make("发送 - \(text)")
        let model = WXDetailModel(text: text)
        model.from = currentSenderID
        model.referencedModel = referenceMsg
        
        //self.dataArray.append(model)
        dataArrayAppendMsg(model)
        XYFileManager.writeFile(with: DataSource_wxDetail.targetDB_filePath, models: self.dataArray)
        
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            self.tableView.scrollToRow(at: IndexPath.init(row: self.dataArray.count-1, section: 0), at: .bottom, animated: true)
        }
        
        // 更新消息列表最后一句话和时间
        self.lsitModel.time = Date().timeIntervalSince1970
        self.lsitModel.lsatMessage = text
        self.lsitModel.updateListMemory()
        self.delegate?.lastMessageDidupdate()
    }
    
    func keyboardWillShow(_ noti: Notification) {
        let cover = UIView()
        cover.tag = 711 // date of create
        view.insertSubview(cover, aboveSubview: tableView)
        cover.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        cover.addTap {[weak self] sender in
            self?.sessionInputView.resignFirstResponder()
        }
    }
    
    func keyboardWillHide(_ noti: Notification) {
        view.findSubView { cover in
            if cover.tag == 711 {
                cover.removeFromSuperview()
                return true
            }
            return false
        }
    }
    
    func functionAction(actionName: String) {
        InputBarAddFunctionHelper.dealAction(with: actionName, forVC: self)
    }
}

//: MARK - special functinos

extension WXDetailViewController {
    
    /// 内存中新增消息对象,内部处理是否需要添加时间戳
    /// - Parameter model: 消息对象
    func dataArrayAppendMsg(_ model: WXDetailModel) {
        if dataArray.isEmpty {
            // 添加一个时间戳
            let time = WXDetailModel(timeInterval: Date().timeIntervalSince1970)
            self.dataArray.append(time)
            self.dataArray.append(model)
        }else{
            // 上一条消息间隔5分钟之内,直接添加新消息
            if let lastMsg = self.dataArray.last,
               let lastTime = lastMsg.timeInterval,
               let currentTime = model.timeInterval,
               currentTime - lastTime < 5 * 60 {
                self.dataArray.append(model)
            }else
            {
                // 上一条消息本身是时间/本身要添加的是时间, 直接添加
                if let lastMsg = self.dataArray.last,
                   lastMsg.msgType == .time || model.msgType == .time {
                    self.dataArray.append(model)
                }else{
                    // 添加一个时间戳
                    let time = WXDetailModel(timeInterval: model.timeInterval)
                    self.dataArray.append(time)
                    self.dataArray.append(model)
                }
            }
        }
        
        tableView.reloadData()
        
        archiveChatDB()
        
        tableViewScrollToBottom()
    }
    
    /// 删除一条消息
    /// - Parameter model: 被删除的消息对象
    func deleteMsgModel(_ model: WXDetailModel) {
        // dataArray delete
        dataArray = dataArray.filter { msgModel in model != msgModel }
        // ui reload
        tableView.reloadData()
        // archive DB
        archiveChatDB()
    }
    
    func reloadTableAndArchiveDB(){
        tableView.reloadData()
        archiveChatDB()
    }
}

