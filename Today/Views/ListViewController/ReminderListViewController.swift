//
//  ViewController.swift
//  Today
//
//  Created by Joshua Baker on 4/14/22.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
    
   
    var dataSource: Datasource!
    var reminders: [Reminder] = Reminder.sampleData
    
    // TODO: try to understand this better.
    var filteredReminders: [Reminder] {
        return reminders.filter { listStyle.shouldInclude(date: $0.dueDate) }.sorted { $0.dueDate < $1.dueDate }
    }
    
    var listStyle: ReminderListStyle = .today
    
    var listStyleSegmentedControl = UISegmentedControl(items: [
        ReminderListStyle.today.name,
        ReminderListStyle.future.name,
        ReminderListStyle.all.name
    ])

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let listLayout = listLayout()
        
        collectionView.collectionViewLayout = listLayout
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        dataSource = Datasource(collectionView: collectionView) { (collectionView: UICollectionView,
                                                                   indexPath: IndexPath,
                                                                   itemIdentifier: Reminder.ID) in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(didPressAddButton(_:)))
        
        addButton.accessibilityLabel = NSLocalizedString("Add Reminder",
                                                         comment: "Add button accessibility label")
        navigationItem.rightBarButtonItem = addButton
        
        updateSnapshot()
        
        collectionView.dataSource = dataSource
    }

    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        
        listConfiguration.showsSeparators = false
        listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        listConfiguration.backgroundColor = .clear
        
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    func showDeatil(for id: Reminder.ID) {
        let reminder = reminder(for: id)
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            self?.update(reminder, with: reminder.id)
            self?.updateSnapshot(reloading: [reminder.id])
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = filteredReminders[indexPath.item].id
        showDeatil(for: id)
        return false
    }
    
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath, let id = dataSource.itemIdentifier(for: indexPath) else {
            return nil
        }
        
        let deleteActionTitle = NSLocalizedString("Delete",
                                                  comment: "Delete action title")
        
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: deleteActionTitle) { [weak self] _, _, completion in
            self?.deleteReminder(with: id)
            self?.updateSnapshot()
            completion(false)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

