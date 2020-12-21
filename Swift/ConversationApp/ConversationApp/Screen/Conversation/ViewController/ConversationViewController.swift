//
//  ConversationViewController.swift
//  ConversationApp
//
//  Created by Scott.L on 21/12/2020.
//

import UIKit

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = ConversationViewModel()
    let searchController = UISearchController(searchResultsController: nil)
    
    var conversationData: [Conversation]?
    var filteredChat: [Conversation] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindModel()
    }
}

private extension ConversationViewController {
    
    func setupUI() {
        customizeNavigationItem()
        tableView.register(cellType: ConversationTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
    }
    
    func bindModel() {
        viewModel.bindConversation()
        viewModel.conversationResults.bindAndFire { results in
            self.conversationData = results
            self.tableView.reloadData()
        }
        
        viewModel.filterChatResults.bindAndFire { results in
            self.filteredChat = results
            self.tableView.reloadData()
        }
        
        viewModel.onShowError = { [weak self] error in
            guard let self = self else { return }
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func customizeNavigationItem() {
        let longTitleLabel = UILabel()
        longTitleLabel.text = "Chats"
        longTitleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        longTitleLabel.sizeToFit()
        
        let leftItem = UIBarButtonItem(customView: longTitleLabel)
        let rightItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchChat))
        rightItem.tintColor = UIColor(named: "searchBarColor")
        
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.rightBarButtonItem = rightItem
    }
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredChat.count
        } else {
            guard let count = conversationData?.count else { return 0 }
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ConversationTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if isFiltering {
            let results = filteredChat[indexPath.row]
            cell.configure(chat: results)
            return cell
        } else {
            guard let results = conversationData?[indexPath.row] else { return UITableViewCell() }
            cell.configure(chat: results)
            return cell
        }
    }
    
    @objc func searchChat() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Chat"
        searchController.hidesNavigationBarDuringPresentation = false
        present(searchController, animated: true, completion: nil)
    }
    
}

extension ConversationViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let searchText = searchBar.text else { return }
        viewModel.filterChat(searchText)
    }
    
}
