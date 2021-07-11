//
//  ReminderListCell.swift
//  Stream2
//
//  Created by Luke Gantar on 7/11/21.
//

import UIKit

class ReminderListCell: UITableViewCell {
    typealias DoneButtonAction = () -> Void
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
 
    var doneButtonAction: DoneButtonAction?
    
    @IBAction func doneButtonTriggered(_ sender: UIButton) {
        doneButtonAction?()
    }
}
