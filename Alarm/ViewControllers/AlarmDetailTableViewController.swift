//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Seth Danner on 7/31/18.
//  Copyright © 2018 Seth Danner. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController, AlarmScheduler {
    
    // MARK: Properties
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alarmTitle: UITextField!
    @IBOutlet weak var enableButton: UIButton!
    
    var alarm: Alarm? {
        didSet {
            if isViewLoaded {
                updateViews()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    // MARK: Actions
    @IBAction func enableButtonTapped(_ sender: UIButton) {
        guard let alarm = alarm else { return }
        AlarmController.shared.toggleEnabled(for: alarm)
        if alarm.enabled {
            scheduleUserNotifications(for: alarm)
        } else {
            cancelUserNotifications(for: alarm)
        }
        updateViews()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = alarmTitle.text,
            let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight else { return }
        let timeIntervalSinceMidnight = datePicker.date.timeIntervalSince(thisMorningAtMidnight)
        if let alarm = alarm {
            AlarmController.shared.update(alarm: alarm, fireTimeFromMidnight: timeIntervalSinceMidnight, name: title)
            cancelUserNotifications(for: alarm)
            scheduleUserNotifications(for: alarm)
        } else {
            let alarm = AlarmController.shared.addAlarm(fireTimeFromMidnight: timeIntervalSinceMidnight, name: title)
            self.alarm = alarm
            scheduleUserNotifications(for: alarm)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        guard let alarm = alarm,
            let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight,
            isViewLoaded else {
                enableButton.isHidden = true
                return
        }
        
        datePicker.setDate(Date(timeInterval: alarm.fireTimeFromMidnight, since: thisMorningAtMidnight), animated: false)
        alarmTitle.text = alarm.name
        
        enableButton.isHidden = false
        if alarm.enabled {
            enableButton.setTitle("Disable", for: UIControlState())
            enableButton.setTitleColor(.white, for: UIControlState())
            enableButton.backgroundColor = .red
        } else {
            enableButton.setTitle("Enable", for: UIControlState())
            enableButton.setTitleColor(.blue, for: UIControlState())
            enableButton.backgroundColor = .gray
        }
        
        self.title = alarm.name
    }
}
