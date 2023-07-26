import Foundation
import SwiftUI
import Sparkle

public struct Updater {
    public static func checkForUpdate() {
        SPUStandardUpdaterController.shared.updater.checkForUpdates()
    }
    
    public static func checkForUpdateSchedule(_ interval: TimeInterval = 86400) {
        if let last = SPUStandardUpdaterController.shared.updater.lastUpdateCheckDate, Date.now < last.addingTimeInterval(interval) { return }
        SPUStandardUpdaterController.shared.updater.checkForUpdatesInBackground()
    }
    
    public static var shared: SPUStandardUpdaterController { SPUStandardUpdaterController.shared }
}

extension SPUStandardUpdaterController {
    public static var shared = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: SPUUser.default)
}

extension SPUStandardUpdaterController {
}


public class SPUUser: NSObject {
    public static var `default` = SPUUser()
}

extension SPUUser: SPUStandardUserDriverDelegate {
    public var supportsGentleScheduledUpdateReminders: Bool { true }
    public func standardUserDriverShouldHandleShowingScheduledUpdate(_ update: SUAppcastItem, andInImmediateFocus immediateFocus: Bool) -> Bool {
        debugPrint("ShouldHandleShowingScheduledUpdate")
        return immediateFocus
    }
    
    public func standardUserDriverWillHandleShowingUpdate(_ handleShowingUpdate: Bool, forUpdate update: SUAppcastItem, state: SPUUserUpdateState) {
        debugPrint("WillHandleShowingUpdate")
        SPUStandardUpdaterController.shared.userDriver.showUpdateInFocus()
    }
    
    public func standardUserDriverDidReceiveUserAttention(forUpdate update: SUAppcastItem) {
        debugPrint("DidReceiveUserAttention")
    }
    
    public func standardUserDriverWillFinishUpdateSession() {
        debugPrint("WillFinishUpdateSession")
        let updater = SPUStandardUpdaterController.shared.updater
        updater.resetUpdateCycle()
    }
}

private func debugPrint(_ msg: String) {
    #if DEBUG
    print(msg)
    #endif
}
