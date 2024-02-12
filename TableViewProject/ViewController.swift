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
    var cleanButton = UIBarButtonItem()
    
    var dataSource: UITableViewDiffableDataSource<Section, Number>!
    var numArray = [Number]()
    
    enum Section {
        case first
    }
    
    struct Number: Hashable {
        var number: Int
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        title = "Task 4"
        
        createTableView()
        createBarButtons()
        
        for i in 0...30 {
            let num = Number(number: i + 1)
            self.numArray.append(num)
            self.updateDatasource()
        }
    }
    
    
    
    private func createTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.layer.cornerRadius = 10
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
            
            let randomedNum = self.numArray.shuffled()
    
            var configurationCell = cell.defaultContentConfiguration()
            configurationCell.text = "\(itemIdentifier.number)"
            cell.contentConfiguration = configurationCell
            
            return cell
        })
    }
    
    
    
    private func createBarButtons() {
        shuffleButton = .init(title: "Shuffle", style: .plain, target: self, action: #selector(shuffleNums))
        navigationItem.rightBarButtonItem = shuffleButton
        
        cleanButton = .init(title: "Clean", style: .plain, target: self, action: #selector(cleanChecks))
        navigationItem.leftBarButtonItem = cleanButton
    }

    
    
    @objc func shuffleNums() {
        numArray.shuffle()
        updateDatasource()
    }
    
    @objc func cleanChecks() {
        let totalRows = tableView.numberOfRows(inSection: 0)
        for row in 0..<totalRows {
            tableView.cellForRow(at: .SubSequence(row: row, section: 0))?.accessoryType = .none
        }
    }
}



extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)

        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            tableView.deselectRow(at: indexPath, animated: true)
            
            if var snap = self.dataSource?.snapshot() {
                let selectedNum = snap.itemIdentifiers[indexPath.row]
                snap.deleteItems([selectedNum])
                snap.insertItems([selectedNum], beforeItem: snap.itemIdentifiers.first ?? .init(number: 1))
                self.dataSource?.apply(snap, animatingDifferences: true)
            }
            
        }
    }
    
    func updateDatasource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Number>()
        snapshot.appendSections([.first])
        snapshot.appendItems(numArray)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}


//    - По нажатию на ячейку она анимировано перемещается на первое место, а справа появляется галочка.
//    - Если нажать на ячейку с галочкой, то галочка пропадает.
//    - Справа вверху кнопка анимировано перемешивает ячейки.
