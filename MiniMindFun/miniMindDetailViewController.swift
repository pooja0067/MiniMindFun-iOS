//
//  miniMindDetailViewController.swift
//  MiniMindFun
//
//  Created by Pooja on 17/11/24.
//

import UIKit

class miniMindDetailViewController: UIViewController {
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var speakerImage: UIImageView!
    @IBOutlet weak var leftImage: UIImageView!
    
    var detailText = ""
    var Items: [ItemType] = []
    var currentIndex = 0
    
    override func viewDidLoad() {
        setUpNavBar()
        displayImage()
        // Ensure the image view is properly connected before adding a gesture
        if rightImage != nil {
            rightAddTapGestureToImage()
        }
        if leftImage != nil {
            leftAddTapGestureToImage()
        }
        leftImage.isUserInteractionEnabled = false
        leftImage.tintColor = .lightGray
    }
    
    func setUpNavBar() {
        self.navigationItem.title = detailText
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(doneButtonTapped))
    }
    
    func rightAddTapGestureToImage() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(rightImageTapped))
        rightImage.isUserInteractionEnabled = true
        rightImage.addGestureRecognizer(tapGesture)
    }
    
    func leftAddTapGestureToImage() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(leftImageTapped))
        leftImage.isUserInteractionEnabled = true
        leftImage.addGestureRecognizer(tapGesture)
    }
    
    func loadItemJSON(typeOfItem: String) {
        self.displayImage()
        // Step 1: Locate the JSON file using `path(forResource:)`
        guard let path = Bundle.main.path(forResource: "numbers", ofType: "json") else {
            print("Failed to locate numbers.json")
            return
        }
        // Step 2: Load the JSON data from the file
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            
            // Step 3: Decode the JSON into your model
            let decoder = JSONDecoder()
            let numberCollection = try decoder.decode(ItemCollection.self, from: data)
            
            // Step 4: Assign the decoded items to your array
            if typeOfItem == "Numbers" {
                self.Items = numberCollection.numbers
            } else if typeOfItem == "Shapes" {
                self.Items = numberCollection.shapes
            }  else if typeOfItem == "Fruits" {
                self.Items = numberCollection.fruits
            }  else if typeOfItem == "Vegetables" {
                self.Items = numberCollection.vegetables
            } else if typeOfItem == "Colors" {
                self.Items = numberCollection.colors
            } else if typeOfItem == "Birds" {
                self.Items = numberCollection.birds
            } else if typeOfItem == "Animals" {
                self.Items = numberCollection.animals
            } else if typeOfItem == "Vehicals" {
                self.Items = numberCollection.vehicals
            } else if typeOfItem == "Profession" {
                self.Items = numberCollection.profession
            } else if typeOfItem == "Alphabets" {
                self.Items = numberCollection.alphabets
            }
            
        } catch {
            print("Failed to load or parse JSON: \(error)")
        }
    }
    
    func getUIImage(named imageName: String) -> UIImage? {
        return UIImage(named: imageName)
    }
    
    // Step 5: Method to display the current image based on the index
    func displayImage() {
        guard !self.Items.isEmpty else {
            print("No images available")
            return
        }
        let currentImage = Items[currentIndex]
        detailLabel.text = currentImage.name
        detailImage.image = UIImage(named: currentImage.path)
    }
    
    // Step 5: Method called when image is tapped
    @objc func rightImageTapped() {
        currentIndex += 1
        // Loop back to the first image if the end is reached
        if currentIndex == Items.count - 1 {
            rightImage.isUserInteractionEnabled = false
            rightImage.tintColor = .lightGray
            leftImage.isUserInteractionEnabled = true
            leftImage.tintColor = .black
        }
        // Display the next image
        if currentIndex != Items.count {
            displayImage()
            leftImage.isUserInteractionEnabled = true
            leftImage.tintColor = .black
        }
    }
    
    // Step 5: Method called when image is tapped
    @objc func leftImageTapped() {
        currentIndex -= 1
        // Loop back to the first image if the end is reached
        if currentIndex == 0 {
            leftImage.isUserInteractionEnabled = false
            leftImage.tintColor = .lightGray
            rightImage.isUserInteractionEnabled = true
            rightImage.tintColor = .black
        }
        // Display the next image
        displayImage()
        rightImage.isUserInteractionEnabled = true
        rightImage.tintColor = .black
    }
    
    @objc func doneButtonTapped() {
        self.dismiss(animated: true , completion: nil)
    }
    
}


