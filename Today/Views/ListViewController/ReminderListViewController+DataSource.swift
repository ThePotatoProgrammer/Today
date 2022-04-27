//
//  ReminderListViewController+DataSource.swift
//  Today
//
//  Created by Joshua Baker on 4/15/22.
//

import UIKit

extension ReminderListViewController {
    typealias Datasource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>
    
    var reminderCompletedValue: String {
        NSLocalizedString("Completed", comment: "Reminder completed value")
    }
    
    var reminderNotCompletedValue: String {
        NSLocalizedString("Not completed", comment: "Reminder not completed value")
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell,
                                 indexPath: IndexPath,
                                 id: Reminder.ID) {
        
        let reminder = reminder(for: id)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration
        
        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        doneButtonConfiguration.tintColor = UIColor(red: 1.0, green: 0.9, blue: 0.2, alpha: 1.0)
        
        cell.accessibilityCustomActions = [
            doneButtonAccessibilityAction(for: reminder)
        ]
        
        cell.accessibilityValue = reminder.isComplete
            ? reminderCompletedValue
            : reminderNotCompletedValue

        cell.accessories = [
            .customView(configuration: doneButtonConfiguration),
            .disclosureIndicator(displayed: .always)
        ]
        
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = UIColor.darkGray
        cell.backgroundConfiguration = backgroundConfiguration
        
    }
    
    private func doneButtonConfiguration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration {
        
        let symbolName = (reminder.isComplete)
            ? "circle.fill"
            : "circle"
            
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        
        let button = ReminderDoneButton()
        button.id = reminder.id
        button.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside)
        button.setImage(image, for: .normal)
        
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }
    
    func reminder(for id: Reminder.ID) -> Reminder {
        let index = reminders.indexOfReminder(with: id)
        return reminders[index]
    }
    
    func update(_ reminder: Reminder, with id: Reminder.ID) {
        let index = reminders.indexOfReminder(with: id)
        reminders[index] = reminder
    }
    
    func completeReminder(with id: Reminder.ID) {
        var reminder = reminder(for: id)
        reminder.isComplete.toggle()
        update(reminder, with: id)
        updateSnapshot(reloading: [id])
    }
    
    func updateSnapshot(reloading ids: [Reminder.ID] = []) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(reminders.map { $0.id })
        
        if !ids.isEmpty {
            snapshot.reloadItems(ids)
        }
        
        dataSource.apply(snapshot)
    }
    
    private func doneButtonAccessibilityAction(for reminder: Reminder) -> UIAccessibilityCustomAction {
        let name = NSLocalizedString("Toggle completion", comment: "Reminder done button acccessibilty label")
        let action = UIAccessibilityCustomAction(name: name) { [weak self] action in
            
            self?.completeReminder(with: reminder.id)
            return true
        }
        
        return action
    }
    
    func add(_ reminder: Reminder) {
        reminders.append(reminder)
    }
    
    func deleteReminder(with id: Reminder.ID) {
        let index = reminders.indexOfReminder(with: id)
        reminders.remove(at: index)
    }
}
