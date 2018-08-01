//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by Seth Danner on 8/1/18.
//  Copyright © 2018 Seth Danner. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate: class {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {
    
    // MARK: Properties and Outlets
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: SwitchTableViewCellDelegate?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    // MARK: Actions
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        delegate?.switchCellSwitchValueChanged(cell: self)
    }
    
    func updateViews() {
        
        guard let alarm = alarm else { return }
        timeLabel.text = alarm.fireTimeAsString
        nameLabel.text = alarm.name
        alarmSwitch.isOn = alarm.enabled
    }
}
