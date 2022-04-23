//
//  ReminderViewController.swift
//  Today
//
//  Created by Joshua Baker on 4/22/22.
//

import UIKit

class ReminderViewController: UICollectionViewController {
    var reminder: Reminder
    
    init(reminder: Reminder) {
        self.reminder = reminder
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        
        super.init(collectionViewLayout: listLayout)
    }
    
    // Interface builder stores achives of the view controllers that you create. A view controller requires an
    // init(coder:) initializer so the system can initialize it using such an archive. If the view controller
    // can't be decoded and constructed, the initialization fails. When constructing an object using a failable
    // initializer, the result is an optional that contains either the initialized object if it succeeds or nil
    // if the initialization fails.
    required init?(coder: NSCoder) {
        fatalError("Always initialize ReminderViewController using init(reminder:)")
    }
    
    func text(for row: Row) -> String? {
        switch row {
            case .viewDate:  return reminder.dueDate.dayText
            case .viewNotes: return reminder.notes
            case .viewTime:  return reminder.dueDate.formatted(date: .omitted, time: .shortened)
            case .viewTitle: return reminder.title
        }
    }
}
