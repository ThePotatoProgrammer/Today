//
//  ReminderViewController.swift
//  Today
//
//  Created by Joshua Baker on 4/22/22.
//

import UIKit

class ReminderViewController: UICollectionViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, Row>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Row>
    
    var reminder: Reminder
    private var dataSource: DataSource!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView,
                                                                   indexPath: IndexPath,
                                                                   itemIdentifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
            
        }
        
        navigationItem.title = NSLocalizedString("Reminder", comment: "Reminder view controller title")
        
        updateSnapshot()
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell,
                                 indexPath: IndexPath,
                                 row: Row) {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = text(for: row)
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
        contentConfiguration.image = row.image
        
        cell.contentConfiguration = contentConfiguration
        cell.tintColor = .darkGray
    }
    
    func text(for row: Row) -> String? {
        switch row {
            case .viewDate:  return reminder.dueDate.dayText
            case .viewNotes: return reminder.notes
            case .viewTime:  return reminder.dueDate.formatted(date: .omitted, time: .shortened)
            case .viewTitle: return reminder.title
        }
    }
    
    func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems([
            .viewTitle,
            .viewDate,
            .viewTime,
            .viewNotes
        ], toSection: 0)
        
        dataSource.apply(snapshot)
    }
}
