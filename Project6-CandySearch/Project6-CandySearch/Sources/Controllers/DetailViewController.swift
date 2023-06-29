//
//  DetailViewController.swift
//  Project6-CandySearch
//
//  Created by 편성경 on 2023/06/29.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var candyNameLabel: UILabel!
    @IBOutlet weak var candyImageView: UIImageView!
    
    var candyData: CandiesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData()
    }
    
    func setData() {
        if let name = candyData?.name {
            candyNameLabel.text = name
            candyImageView.image = UIImage(named: name)
        }
    }

}
