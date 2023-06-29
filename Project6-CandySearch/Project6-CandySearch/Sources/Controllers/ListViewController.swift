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
        self.navigationItem.searchController = searchController
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
        }
        
    }
    
    // MARK: - Setting UITableView
    func configUITableView() {
        listTableView.dataSource = self
        listTableView.delegate = self
    }

}

// MARK: - EXTENSION UITableViewDataSource
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return candies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = listTableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        cell.candyNameLabel.text = candies?[indexPath.row].name
        cell.candyTypeLabel.text = candies?[indexPath.row].category
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        detailVC.candyData = candies?[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
