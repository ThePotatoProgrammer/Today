//
//  EKReminder+Reminder.swift
//  Today
//
//  Created by Joshua Baker on 4/30/22.
//

import Foundation
import EventKit

extension EKReminder {
    func update(using reminder: Reminder, in store: EKEventStore) {
        title = reminder.title
        notes = reminder.notes
        isCompleted = reminder.isComplete
        
        calendar = store.defaultCalendarForNewReminders()
        
        // TODO: learn more about this.
        alarms?.forEach { alarm in
            guard let absoluteDate = alarm.absoluteDate else {
                return
            }
            
            let comparison = Locale.current.calendar.compare(reminder.dueDate,
                                                             to: absoluteDate,
                                                             toGranularity: .minute)
            
            if comparison != .orderedSame {
                removeAlarm(alarm)
            }
        }
        
        if !hasAlarms {
            addAlarm(EKAlarm(absoluteDate: reminder.dueDate))
        }
    }
}
