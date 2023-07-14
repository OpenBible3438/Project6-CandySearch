//
//  ViewController.swift
//  Project6-CandySearch
//
//  Created by 최우태 on 2023/06/20.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    var candies: [CandiesModel]?
    var filteredCandies: [CandiesModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchBar()
        getData()
        configUITableView()
    }
    
    // MARK: - Setting SearchController
    func setSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - Get candies.json data
    func getData() {
        guard let path = Bundle.main.path(forResource: "candies", ofType: "json") else {
            print("candies.json path ERROR")
            return
        }
        
        guard let jsonString = try? String(contentsOfFile: path) else {
            print("path to String ERROR")
            return
        }
        
        let data = jsonString.data(using: .utf8)
        if let data = data,
           let candy = try? JSONDecoder().decode([CandiesModel].self, from: data) {
            candies = candy
            filteredCandies = candy
        }
        
    }
    
    // MARK: - Setting UITableView
    func configUITableView() {
        listTableView.dataSource = self
        listTableView.delegate = self
    }

}

// MARK: - EXTENSION UITableViewDataSource, UITableViewDelegate
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCandies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = listTableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        cell.candyNameLabel.text = filteredCandies?[indexPath.row].name
        cell.candyTypeLabel.text = filteredCandies?[indexPath.row].category
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        detailVC.candyData = filteredCandies?[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

// MARK: - EXTENSION UISearchResultsUpdating
extension ListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    // SearchBar에 검색할 때 호출
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        if searchText.isEmpty {
            filteredCandies = candies
            self.listTableView.reloadData()
            return
        }
        
        filterData(searchText, scope: searchController.searchBar.scopeButtonTitles![searchController.searchBar.selectedScopeButtonIndex])
    }
    
    func filterData(_ searchText: String, scope: String) {
        filteredCandies = candies?.filter {
            if !(scope == "All") {
                return false
            }
            return $0.name.localizedCaseInsensitiveContains(searchText)
        }
        self.listTableView.reloadData()
    }

}
