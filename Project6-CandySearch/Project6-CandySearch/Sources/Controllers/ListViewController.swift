//
//  ViewController.swift
//  Project6-CandySearch
//
//  Created by 최우태 on 2023/06/20.
//

import UIKit

class ListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchBar()
    }
    
    func setSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
        self.navigationItem.searchController = searchController
    }

}
