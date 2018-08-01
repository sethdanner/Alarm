//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by Seth Danner on 8/1/18.
//  Copyright © 2018 Seth Danner. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    // MARK: Actions
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        
    }
}
