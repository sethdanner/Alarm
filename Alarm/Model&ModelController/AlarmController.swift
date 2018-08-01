//
//  AlarmController.swift
//  Alarm
//
//  Created by Seth Danner on 8/1/18.
//  Copyright © 2018 Seth Danner. All rights reserved.
//

import Foundation
import UserNotifications

protocol AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

class AlarmController {
    
    // MARK: Properties
    var alarms: [Alarm] = []
    static let shared = AlarmController()
    
    init() {
        loadFromPersistentStorage()
    }
    
    // MARK: CRUD Functions
    func addAlarm(fireTimeFromMidnight: TimeInterval, name: String) -> Alarm {
        
        let newAlarm = Alarm(fireTimeFromMidnight: fireTimeFromMidnight, name: name)
        alarms.append(newAlarm)
        saveToPersistentStorage()
        return newAlarm
    }
    
    func update(alarm: Alarm, fireTimeFromMidnight: TimeInterval, name: String) {
        
        alarm.fireTimeFromMidnight = fireTimeFromMidnight
        alarm.name = name
        saveToPersistentStorage()
    }
    
    func delete(alarm: Alarm) {
        
        guard let index = alarms.index(of: alarm) else { return }
        alarms.remove(at: index)
        saveToPersistentStorage()
    }
    
    // MARK: Load/Save
    private func saveToPersistentStorage() {
        guard let filePath = type(of: self).persistentAlarmsFilePath else { return }
        NSKeyedArchiver.archiveRootObject(self.alarms, toFile: filePath)
    }
    
    private func loadFromPersistentStorage() {
        guard let filePath = type(of: self).persistentAlarmsFilePath else { return }
        guard let alarms = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Alarm] else { return }
        self.alarms = alarms
    }
    
    static private var persistentAlarmsFilePath: String? {
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        guard let documentsDirectory = directories.first as NSString? else { return nil }
        return documentsDirectory.appendingPathComponent("Alarms.plist")
    }
    
    func toggleEnabled(for alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        saveToPersistentStorage()
    }
}

extension AlarmScheduler {
    
    func scheduleUserNotifications(for alarm: Alarm) {
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Time's up!"
        notificationContent.body = "Your alarm titled \(alarm.name) is done"
        notificationContent.sound = UNNotificationSound.default()
        
        guard let fireDate = alarm.fireDate else { return }
        let triggerDate = Calendar.current.dateComponents([.hour, .minute, .second], from: fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        
        let request = UNNotificationRequest(identifier: alarm.uuid, content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Unable to add notification request, \(error.localizedDescription)")
            }
        }
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}
