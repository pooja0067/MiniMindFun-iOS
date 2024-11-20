//
//  ViewController.swift
//  MiniMindFun
//
//  Created by Pooja on 15/11/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let items = ["Alphabets", "Numbers", "Colors",  "Fruits", "Vegetables", "Animals", "Birds", "Vehicals", "Profession", "Shapes"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "MiniMindFun"
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func navigateToDetailViewController(indexPath: IndexPath) {
        
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "miniMindDetailViewController") as? miniMindDetailViewController else {
            print("Failed to instantiate miniMindDetailViewController")
            return
        }
        
        detailVC.detailText = items[indexPath.item]
        
        let navController = UINavigationController(rootViewController: detailVC)
        navController.modalPresentationStyle = .fullScreen
        
        // Present the view controller
        guard let navigationController = navigationController else {
            print("Navigation controller is nil")
            return
        }
        navigationController.present(navController, animated: true)
        
        if items[indexPath.row] == "Shapes" || items[indexPath.row] == "Colors" || items[indexPath.row] == "Numbers" || items[indexPath.row] == "Alphabets" || items[indexPath.row] == "Fruits" || items[indexPath.row] == "Vehicals" || items[indexPath.row] == "Birds" || items[indexPath.row] == "Animals" || items[indexPath.row] == "Profession"  || items[indexPath.row] == "Vegetables" {
            detailVC.loadItemJSON(typeOfItem: items[indexPath.row])
        }
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return items.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "miniMindCollectionCell", for: indexPath) as? miniMindCollectionCell else {
               return UICollectionViewCell()
           }
           cell.title.text = items[indexPath.item]
           cell.image.image = UIImage(named: "\(items[indexPath.item])")
           return cell
       }
       
       // MARK: - UICollectionViewDelegate Method (Optional)
       
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           navigateToDetailViewController(indexPath: indexPath)
       }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height:  500)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16 // Vertical spacing between rows
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16 // Horizontal spacing between items
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 30, bottom: 24, right: 30)
    }
    
}
