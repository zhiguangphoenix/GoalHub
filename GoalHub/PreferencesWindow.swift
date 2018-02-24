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
    func updateFre(timeInterval: Double)
}

class PreferencesWindow: NSWindowController {
    @IBOutlet weak var userInput: NSTextField!
    @IBOutlet weak var tokenInput: NSTextField!
    @IBOutlet weak var goalInput: NSComboBox!
    @IBOutlet weak var userUpdatedNoti: NSTextField!
    @IBOutlet weak var tokenUpdatedNoti: NSTextField!
    @IBOutlet weak var goalUpdatedNoti: NSTextField!
    @IBOutlet weak var logo: NSImageView!
    @IBOutlet weak var FrequencySelect: NSPopUpButton!
    @IBOutlet weak var frequencyUpdateNoti: NSTextField!
    
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
        let fre = defaults.integer(forKey: "fre")
        if fre > 0 {
            switch fre {
            case 7200:
                FrequencySelect.selectItem(withTitle: "2h")
            case 21600:
                FrequencySelect.selectItem(withTitle: "6h")
            case 43200:
                FrequencySelect.selectItem(withTitle: "12h")
            case 86400:
                FrequencySelect.selectItem(withTitle: "24h")
            default:
                break
            }
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
    
    @IBAction func updateFrequency(_ sender: NSButton) {
        let defaults = UserDefaults.standard
        let fre = FrequencySelect.selectedItem!.title
        
        switch fre {
        case "2h":
            defaults.set(7200, forKey: "fre")
            delegate?.updateFre(timeInterval: 7200)
        case "6h":
            defaults.set(21600, forKey: "fre")
            delegate?.updateFre(timeInterval: 21600)
        case "12h":
            defaults.set(43200, forKey: "fre")
            delegate?.updateFre(timeInterval: 43200)
        case "24h":
            defaults.set(86400, forKey: "fre")
            delegate?.updateFre(timeInterval: 86400)
        default:
            defaults.set(21600, forKey: "fre")
            delegate?.updateFre(timeInterval: 21600)
        }
        
        frequencyUpdateNoti.stringValue = "👌Updated!"
        delayRemoveText(frequencyUpdateNoti, 3)
    }
    
    func delayRemoveText(_ field: NSTextField, _ delay: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            field.stringValue = ""
        }
    }
}
