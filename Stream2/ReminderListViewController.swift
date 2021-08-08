import UIKit

class ReminderListViewController: UITableViewController {
    @IBOutlet var filterSegmentedControl: UISegmentedControl!
    
    static let showDetailSegueIdentifier = "ShowReminderDetailSegue"
    static let mainStoryboardName = "Main"
    static let detailViewControllerIdentifier = "ReminderDetailViewController"

    private var reminderListDataSource: ReminderListDataSource?
    private var filter: ReminderListDataSource.Filter {
        return ReminderListDataSource.Filter(rawValue: filterSegmentedControl.selectedSegmentIndex) ?? .today
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Self.showDetailSegueIdentifier,
            let destination = segue.destination as? ReminderDetailViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
            let rowIndex = indexPath.row
            guard let reminder = reminderListDataSource?.reminder(at: rowIndex) else {
                fatalError("Couldn't find data source for reminder list.")
            }
            destination.configure(with: reminder, editAction: { reminder in
                self.reminderListDataSource?.update(reminder, at: rowIndex)
                self.tableView.reloadData()
            })
        }
    }

    
    
    override func viewDidLoad() {
        filterSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        
        super.viewDidLoad()
        reminderListDataSource = ReminderListDataSource(reminderCompletedAction: { reminderIndex in
            self.tableView.reloadRows(at: [IndexPath(row: reminderIndex, section: 0)], with: .automatic)
        }, reminderDeletedAction: {
        })
        tableView.dataSource = reminderListDataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navigationController = navigationController,
            navigationController.isToolbarHidden {
            navigationController.setToolbarHidden(false, animated: animated)
        }
    }

    @IBAction func addButtonTriggered(_ sender: UIBarButtonItem) {
        addReminder()
    }
    
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        reminderListDataSource?.filter = filter
        tableView.reloadData()
    }

    private func addReminder() {
        let storyboard = UIStoryboard(name: Self.mainStoryboardName, bundle: nil)
        let detailViewController: ReminderDetailViewController = storyboard.instantiateViewController(identifier: Self.detailViewControllerIdentifier)
        let reminder = Reminder(id: UUID().uuidString, title: "New Reminder", dueDate: Date())
        detailViewController.configure(with: reminder, isNew: true, addAction: { reminder in
            if let index = self.reminderListDataSource?.add(reminder) {
                self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        })
        let navigationController = UINavigationController(rootViewController: detailViewController)
        present(navigationController, animated: true, completion: nil)
    }
}
