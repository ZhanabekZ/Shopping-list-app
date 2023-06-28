//
//  ViewController.swift
//  Project4-6
//
//  Created by ZhZinekenov on 21.03.2023.
//

import UIKit

class ViewController: UITableViewController {
    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Collect your shopping list"
        
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeAll))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        toolbarItems = [share]
        navigationController?.isToolbarHidden = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Enter item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Add", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func shareTapped() {
        let list = shoppingList.joined(separator: "\n")
        
        let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    
    func submit(_ answer: String) {
        let errorTitle: String
        
        if !answer.isEmpty {
            shoppingList.insert(answer, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            return
        }
        else {
            errorTitle = "You have written nothing."
        }
        showErrorMessage(errorTitle: errorTitle)
    }
    
    @objc func removeAll() {
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    func showErrorMessage(errorTitle: String) {
        let ac = UIAlertController(title: errorTitle, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            shoppingList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .middle)
            
        }
    }
    
}
