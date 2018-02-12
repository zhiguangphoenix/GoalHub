//
//  PreferencesWindow.swift
//  GoalHub
//
//  Created by 杨钺 on 2018/2/10.
//  Copyright © 2018年 ilime. All rights reserved.
//

import Cocoa

protocol PreferencesWindowDelegate {
    func preferencesDidUpdate()
    func updateGoal()
}

class PreferencesWindow: NSWindowController {
    @IBOutlet weak var userInput: NSTextField!
    @IBOutlet weak var tokenInput: NSTextField!
    @IBOutlet weak var goalInput: NSComboBox!
    @IBOutlet weak var userUpdatedNoti: NSTextField!
    @IBOutlet weak var tokenUpdatedNoti: NSTextField!
    @IBOutlet weak var goalUpdatedNoti: NSTextField!
    @IBOutlet weak var logo: NSImageView!
    
    var delegate: PreferencesWindowDelegate?
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name(rawValue: "PreferencesWindow")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        fillTokenInput()
        logo.image = NSImage(named: NSImage.Name(rawValue: "AppIcon"))
    }
    
    func fillTokenInput() {
        let defaults = UserDefaults.standard
        
        if let token = defaults.string(forKey: "token") {
            tokenInput.stringValue = token
        }
        if let user = defaults.string(forKey: "user") {
            userInput.stringValue = user
        }
        if let goal = defaults.string(forKey: "goal") {
            goalInput.stringValue = goal
        }
    }
    
    @IBAction func updateToken(_ sender: NSButton) {
        let defaults = UserDefaults.standard
        let token = tokenInput.stringValue
        
        defaults.set(token, forKey: "token")
        delegate?.preferencesDidUpdate()
        tokenUpdatedNoti.stringValue = "👌Updated!"
        delayRemoveText(tokenUpdatedNoti, 3)
    }
    
    @IBAction func updateUser(_ sender: NSButton) {
        let defaults = UserDefaults.standard
        let user = userInput.stringValue
        
        defaults.set(user, forKey: "user")
        delegate?.preferencesDidUpdate()
        userUpdatedNoti.stringValue = "👌Updated!"
        delayRemoveText(userUpdatedNoti, 3)
    }
    
    @IBAction func updateGoal(_ sender: NSButton) {
        let defaults = UserDefaults.standard
        let goal = goalInput.stringValue
        
        defaults.set(goal, forKey: "goal")
        delegate?.updateGoal()
        goalUpdatedNoti.stringValue = "👌Updated!"
        delayRemoveText(goalUpdatedNoti, 3)
    }
    
    func delayRemoveText(_ field: NSTextField, _ delay: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            field.stringValue = ""
        }
    }
}
