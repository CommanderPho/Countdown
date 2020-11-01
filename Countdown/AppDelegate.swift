//
//  AppDelegate.swift
//  Countdown
//
//  Created by funway on 2020/7/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // 类型后面用 ! 号表示这是一个隐式解析的可选类型
    var statusBarController: StatusBarController!
    var eventListController: EventListNSTableController!
    var reminderTimer: Timer!
    
    #if DEBUG
    var window: NSWindow!
    #endif

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // 初始化日志模块
        initLog()
        
        // 初始化 SQLite 数据库模块
        initSQLite()
               
        // 创建状态栏弹出框视图
        let popover = NSPopover()
        let popoverView = PopRootView().environmentObject(UserData.shared)
        // 必须先为 NSPopover 设置视图控制器后才能添加视图
        popover.contentViewController = PopRootViewController()
        popover.contentViewController?.view = NSHostingView(rootView: popoverView)
        popover.contentSize = NSSize(width: 360, height: 360)
        
        // 创建状态栏图标控制器
        statusBarController = StatusBarController(popover)
    
        // 创建桌面“便利贴”视图
        for cdEvnent in UserData.shared.countdownEvents {
            if cdEvnent.showStickyNote {
                StickyNoteController.shared.add(for: cdEvnent)
            }
        }
        
        // 创建列表视图的 NSTableView
        // 由于 NSTableView 对象的创建与刷新会比较耗时，所以单独摘出来做一个全局共享对象
        eventListController = EventListNSTableController(userData: UserData.shared)
        
        
        // 启动计时器，轮询所有倒计时事件，看看是否需要弹出倒计时结束的通知
        reminderTimer = Timer.scheduledTimer(withTimeInterval: 1,
                                             repeats: true,
                                             block: { _ in
                                                
                                                for cdEvent in UserData.shared.countdownEvents {
                                                    if cdEvent.remindMe && (Int(cdEvent.endAt.timeIntervalSince1970) == Int(Date().timeIntervalSince1970)) {
                                                        Helper.sendCountdownNotification(for: cdEvent)
                                                    }
                                                }
                                             })
        
        
        ////////////// 👇下面这部分代码可以删除了
        
        #if DEBUG
        // Create the SwiftUI view that provides the window contents.
        let contentView = TestDatePicker()
        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        #endif
        
        ////////////// 👆上面这部分代码可以删除了
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

