//
//  ChannelsVC.swift
//  CoChat
//
//  Created by Aaron B on 2/22/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

@objc protocol ChannelsVCDelegate {
    optional func channelsVC(channelsVC: ChannelsVC, didCreateChannel channel: AnyObject)
}

class ChannelsVC: UIViewController {
    weak var delegate: ChannelsVCDelegate?
    var toggleCompressedView = true
    var toggleAdvancedSettings = false
    var room:Room?
    var tempRoom:String?
    var nameOfChannel:String?
    var channelPassCode:String?
    var createChannels = false
    var privateRoom = 0
    
    var channels:[Channel]?
    
    @IBOutlet var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibsForTableView()
        setUpUI()
        
        if channels == nil {
            channels = [Channel]()
        }
    }
    
    func registerNibsForTableView(){
        let headerNib = UINib(nibName: "HostReusableCell", bundle: nil)
        tableView.registerNib(headerNib, forCellReuseIdentifier: "ChannelInformationCell")
    }
    
    func setUpUI(){
        tableView.separatorStyle = .None
        tableView.backgroundColor = Theme.Colors.BackgroundColor.color
        let addChannelButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ChannelsVC.addChannelButtonWasTapped))
        addChannelButton.enabled = false
        navigationItem.rightBarButtonItem = addChannelButton
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChannelsVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChannelsVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    func keyboardWillShow(notification: NSNotification){
        animateTableView(notification)
    }
    
    func keyboardWillHide(notification: NSNotification){
        animateTableView(notification)
    }
    
    func animateTableView(notification: NSNotification){
        let userInfo = notification.userInfo!
        
        let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! UInt
        
        if notification.name == UIKeyboardWillShowNotification {
            let keyHeight = keyboardSize.height // move up
            tableView.contentInset = UIEdgeInsetsMake(0, 0, keyHeight, 0)
        }
        else {
            let keyHeight = keyboardSize.height
            tableView.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.frame.height + keyHeight)
        }
        tableView.setNeedsUpdateConstraints()
        
        let options = UIViewAnimationOptions(rawValue: curve << 16)
        UIView.animateWithDuration(duration, delay: 0, options: options,
            animations: {
                self.tableView.layoutIfNeeded()
                
            },
            completion: nil
        )
        
    }
}



extension ChannelsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChannelInformationCell") as! HostReusableCell
        cell.delegate = self
        cell.resetCellUI()
        switch(indexPath.section, indexPath.row){
        case (0 , indexPath.row):
            if channels!.count != 0 {
                cell.title.userInteractionEnabled = false
                cell.title.text = channels![indexPath.row].title
                return cell
            }
            else{
                cell.hidden = true
                cell.title.textColor = UIColor.whiteColor()
            }
        case (1,0):
            if toggleCompressedView == true {
                cell.title.text = "Add a Channel"
                cell.title.userInteractionEnabled = false
                cell.addButton.hidden = false
                cell.userInteractionEnabled = true
                cell.setHeaderUI()
                return cell
            }
            else {
                cell.title.text = "Create Channel"
                cell.title.userInteractionEnabled = false
                cell.selectionStyle = .None
                cell.setHeaderUI()
                return cell
            }
        default:
            cell.setUpCellAtIndexPath(indexPath)
        }
        return cell
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if toggleCompressedView == true {
            // show created channels || no header and the addRoom cell
            return 2
        }
        else {
            // non compressed view showing the created channels || no header & the create room & the basic info
            return 4
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0://header
            return channels!.count
        case 1://create or add room
            return 1
        case 2://basic info
            return 1
        default: //advancedSettingsDecompressed
            if toggleAdvancedSettings == true {
                return 3
            }//advancedSettingsCompressed
            else {
                return 1
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row){
        case (1,0):
            toggleCompressedView = false
            tableView.reloadData()
        case (3,0):
            toggleAdvancedSettings = !toggleAdvancedSettings
            tableView.scrollEnabled = true
            let index = NSIndexSet(index: 3)
            tableView.reloadSections(index, withRowAnimation: UITableViewRowAnimation.Fade)
        default:break
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66
    }
}

extension ChannelsVC: HostReusableCellDelegate {
    func hostReusableCell(cell: HostReusableCell, valueDidChange: AnyObject?) {
        switch cell.type {
        case .NameOfRoom:
            nameOfChannel = valueDidChange as? String
            if nameOfChannel?.characters.count > 1 {
                navigationItem.rightBarButtonItem?.enabled = true
            }
            else {
                navigationItem.rightBarButtonItem?.enabled = false
            }
        case .PasscodeOfRoom:
            channelPassCode = valueDidChange as? String
        case .Privacy:
            let privacy = valueDidChange as! Bool
            privateRoom = convertBooltoInt(privacy)
        default:
            assertionFailure()
        }
    }
    
    //MARK - FireBase Calls
    func addChannelButtonWasTapped(){
        toggleCompressedView = true
        guard let name = nameOfChannel else { return }
        if let enteredPassCode = channelPassCode {
            FirebaseManager.manager.checkForUniqueEntryKey(enteredPassCode) { result in
                if result {
                    self.addNewChannel(name, privateRoom: self.privateRoom, password: enteredPassCode)
                    return
                }
                else{
                    self.alertNonUniquePassCode()
                }
            }
        }
        else {
            createRandomPassCode()
        }
    }
    
    func addNewChannel(name:String, privateRoom:Int, password:String){
        let newChannel = Channel(withTempTitle: name, tempPrivateChannel: privateRoom, tempPassword: password, roomName: "placeholder")
        channels?.append(newChannel)
        delegate?.channelsVC!(self, didCreateChannel: newChannel)
        tableView.reloadData()
    }
    
    func createRandomPassCode() {
        let passCode = generateRandomPassCode()
        FirebaseManager.manager.checkForUniqueEntryKey(passCode) { (result) -> () in
            if result {
                self.addNewChannel(self.nameOfChannel!, privateRoom: self.privateRoom, password: passCode)
                return
            }
            else {
                self.createRandomPassCode()
            }
        }
        }
    
    func addNewChannel(sender: AnyObject?) {
        toggleCompressedView = false
        tableView.reloadData()
    }
    
    func textFieldDidBeginEditingInCell(textField: UITextField) {
    }
    func textFieldDidEndEditingInCell() {
        tableView.setContentOffset(CGPointMake(0.0, 0.0), animated:true)
    }
}