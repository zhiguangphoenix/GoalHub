//
//  StatusMenuController.swift
//  GoalHub
//
//  Created by 杨钺 on 2018/2/9.
//  Copyright © 2018年 ilime. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject, PreferencesWindowDelegate, NSUserNotificationCenterDelegate {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var preferences: NSMenuItem!
    @IBOutlet weak var quit: NSMenuItem!
    @IBOutlet weak var goalView: GoalView!
    @IBOutlet weak var eventsView: EventsView!
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    var preferencesWindow: PreferencesWindow!
    var githubClient: GithubClient!
    var goalMenuItem: NSMenuItem!
    var eventMenuItem: NSMenuItem!
    var notiTimer: Timer!
    
    override func awakeFromNib() {
        initStatusMenu()
        initPreferencesWindow()
        initCustomView()
        
        githubClient = GithubClient()
        githubClient.fetchProfile(callback: updateGoalView)
        githubClient.fetchEvents(callback: updateEventsView)
        
        notiTimer = Timer.scheduledTimer(timeInterval: 7200, target: self, selector: #selector(registerNoti), userInfo: nil, repeats: true)
    }
    
    @objc func registerNoti() {
        let noti = NSUserNotification()
        noti.title = "Update Data"
        noti.informativeText = "Current User: \(githubClient.user)"
        
        githubClient.fetchProfile(callback: updateGoalView)
        githubClient.fetchEvents(callback: updateEventsView)
        
        let nc = NSUserNotificationCenter.default
        nc.delegate = self
        nc.scheduleNotification(noti)
    }
    
    func updateGoal() {
        goalView.goalText.stringValue = UserDefaults.standard.string(forKey: "goal")!
    }
    
    func preferencesDidUpdate() {
        let defaults = UserDefaults.standard
        let user = defaults.string(forKey: "user")
        let token = defaults.string(forKey: "token")
        
        if (user != githubClient.user) {
            githubClient.updateUser()
            githubClient.fetchProfile(callback: updateGoalView)
            githubClient.fetchEvents(callback: updateEventsView)
        }
        if (token != githubClient.token) {
            githubClient.updateToken()
            githubClient.fetchEvents(callback: updateEventsView)
        }
    }
    
    func updateEventsView(_ eventsDict: [String: Int]) {
        eventsView.push.stringValue = String(describing: eventsDict["PUSH"]!) + " times 🍺"
        eventsView.issue.stringValue = String(describing: eventsDict["ISSUE"]!) + " times 🧀"
        eventsView.pullRequest.stringValue = String(describing: eventsDict["PULLREQUEST"]!) + " times 🍭"
    }
    
    func updateGoalView(_ now: String) {
        if let goal = UserDefaults.standard.string(forKey: "goal") {
            goalView.goalText.stringValue = goal
        }
        goalView.nowText.stringValue = now
    }
    
    func initCustomView() {
        goalMenuItem = statusMenu.item(withTitle: "Goal")
        goalMenuItem.view = goalView
        eventMenuItem = statusMenu.item(withTitle: "Events")
        eventMenuItem.view = eventsView
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
        notiTimer.invalidate()
        NSApplication.shared.terminate(sender)
    }
    
    @IBAction func updateClicked(_ sender: NSMenuItem) {
        registerNoti()
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
}
