//
//  ReminderListViewController+Actions.swift
//  Today
//
//  Created by Joshua Baker on 4/21/22.
//

import UIKit

extension ReminderListViewController {
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        guard let id = sender.id else { return }
        completeReminder(with: id)
    }
}
