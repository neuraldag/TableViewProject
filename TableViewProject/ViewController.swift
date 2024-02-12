//
//  ViewController.swift
//  TableViewProject
//
//  Created by Gamid Gapizov on 11.02.2024.
//

import UIKit

class ViewController: UIViewController {
    
    var tableView = UITableView()
    var shuffleButton = UIBarButtonItem()
    
    var dataSource: UITableViewDiffableDataSource<Section, Row>!
    
    enum Section {
        case first
    }
    
    struct Row: Hashable, Sendable {
        var number: Int
        var selected: Bool
    }
    var rowArray = [Row]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        title = "Task 4"
        
        createTableView()
        createBarButtons()
        
        for i in 0...30 {
            let row = Row(number: i, selected: false)
            self.rowArray.append(row)
            self.updateDatasource()
        }
    }
    
    
    
    private func createTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.layer.cornerRadius = 10
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsMultipleSelection = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 40)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

            var configurationCell = cell.defaultContentConfiguration()
            configurationCell.text = "\(itemIdentifier.number)"
            cell.contentConfiguration = configurationCell
            cell.accessoryType = itemIdentifier.selected ? .checkmark : .none
            
            return cell
        })
    }
    
    
    private func createBarButtons() {
        shuffleButton = .init(title: "Shuffle", style: .plain, target: self, action: #selector(shuffleNums))
        navigationItem.rightBarButtonItem = shuffleButton
    }
    
    @objc func shuffleNums() {
        rowArray.shuffle()
        updateDatasource()
    }
}



extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        
        rowArray[indexPath.row].selected = !rowArray[indexPath.row].selected
        
        if rowArray[indexPath.row].selected {
            let selectedNumber = rowArray[indexPath.row]
            rowArray.remove(at: indexPath.row)
            rowArray.insert(selectedNumber, at: 0)
            dataSource.defaultRowAnimation = .top
            updateDatasource()
        } else {
            dataSource.defaultRowAnimation = .none
            updateDatasource()
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func updateDatasource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        snapshot.deleteAllItems()
        snapshot.appendSections([.first])
        snapshot.appendItems(rowArray)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
