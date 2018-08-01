//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by Seth Danner on 7/31/18.
//  Copyright © 2018 Seth Danner. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController, SwitchTableViewCellDelegate, AlarmScheduler {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return AlarmController.shared.alarms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell ?? SwitchTableViewCell()

        cell.alarm = AlarmController.shared.alarms[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarmTodelete = AlarmController.shared.alarms[indexPath.row]
            AlarmController.shared.delete(alarm: alarmTodelete)
            cancelUserNotifications(for: alarmTodelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let detailVC = segue.destination as? AlarmDetailTableViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.alarm = AlarmController.shared.alarms[indexPath.row]
        }
    }
    
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let alarm = AlarmController.shared.alarms[indexPath.row]
        AlarmController.shared.toggleEnabled(for: alarm)
        if alarm.enabled {
            scheduleUserNotifications(for: alarm)
        } else {
            cancelUserNotifications(for: alarm)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
