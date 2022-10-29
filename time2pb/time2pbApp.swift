//
//  time2pbApp.swift
//  time2pb
//
//  Created by 岡野真空 on 2022/10/29.
//

import SwiftUI

@main
struct time2pbApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        Settings{}
    }
}

class AppDelegate: NSObject, NSApplicationDelegate{
    var statusBarItem: NSStatusItem!
    var popover = NSPopover()
    
    @ObservedObject var timeDataHelper=TimeDataHelper.shared
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory) ///起動時にドックにアプリを表示しない
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: ContentView())
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        guard let button = self.statusBarItem.button else { return }

        button.image = NSImage(systemSymbolName: "timer", accessibilityDescription: nil)
        button.action = #selector(menuButtonAction(sender:))
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }
    
    func getHHmm()->String{

        let dateFormatter = DateFormatter()

        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        dateFormatter.dateFormat = "HH:mm"

        let dateString = dateFormatter.string(from: Date())
        return dateString
    }
    
    @objc func menuButtonAction(sender: AnyObject) {
        guard let event = NSApp.currentEvent else { return }

        if event.type == NSEvent.EventType.rightMouseUp {
            let menu = NSMenu()
            menu.addItem(
                withTitle: NSLocalizedString("Quit", comment: "Quit app"),
                action: #selector(buttonQuit),
                keyEquivalent: ""
            )
            statusBarItem.menu = menu
            statusBarItem.button?.performClick(nil)
            statusBarItem.menu = nil
            return
            
        }else if event.type == NSEvent.EventType.leftMouseUp {
            guard let button = self.statusBarItem.button else { return }
            self.timeDataHelper.timedata = getHHmm()
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(self.timeDataHelper.timedata!, forType: .string)
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                self.popover.contentViewController?.view.window?.makeKey() /// 他の位置をタップすると消える
            }
        }
    }
    
    @objc func buttonQuit(){
        NSApp.terminate(self)
    }
}

class TimeDataHelper:NSObject,ObservableObject{
    static let shared = TimeDataHelper()
    @Published var timedata:String?
}
