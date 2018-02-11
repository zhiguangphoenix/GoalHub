//
//  StatusMenuController.swift
//  GoalHub
//
//  Created by 杨钺 on 2018/2/9.
//  Copyright © 2018年 ilime. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject, PreferencesWindowDelegate {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var preferences: NSMenuItem!
    @IBOutlet weak var quit: NSMenuItem!
    @IBOutlet weak var goalView: GoalView!
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    var preferencesWindow: PreferencesWindow!
    var githubClient: GithubClient!
    var goalMenuItem: NSMenuItem!
    
    override func awakeFromNib() {
        initStatusMenu()
        initPreferencesWindow()
        initGoalView()
        
        githubClient = GithubClient()
        githubClient.fetchProfile(callback: updateGoalView)
    }
    
    func preferencesDidUpdate() {
        githubClient.updateUserAndToken()
        githubClient.fetchProfile(callback: updateGoalView)
    }
    
    func updateGoalView(_ now: String) {
        if let goal = UserDefaults.standard.string(forKey: "goal") {
            goalView.goalText.stringValue = goal
        }
        goalView.nowText.stringValue = now
    }
    
    func initGoalView() {
        goalMenuItem = statusMenu.item(withTitle: "Goal")
        goalMenuItem.view = goalView
    }
    
    func initStatusMenu() {
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name(rawValue: "statusMenuIcon"))
            statusItem.menu = statusMenu
        }
    }
    
    func initPreferencesWindow() {
        preferencesWindow = PreferencesWindow()
        preferencesWindow.delegate = self
    }
    
    @IBAction func profileClicked(_ sender: NSMenuItem) {
        if let user = UserDefaults.standard.string(forKey: "user") {
            NSWorkspace.shared.open(URL(string: "https://github.com/\(user)")!)
        }
    }
    
    @IBAction func preferencesClicked(_ sender: NSMenuItem) {
        preferencesWindow.showWindow(sender)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(sender)
    }
}
