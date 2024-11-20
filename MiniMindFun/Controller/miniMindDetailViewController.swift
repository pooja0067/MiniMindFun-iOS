//
//  miniMindDetailViewController.swift
//  MiniMindFun
//
//  Created by Pooja on 17/11/24.
//

import UIKit
import AVFoundation

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
    private var currentWord: String = ""
    let speechSynthesizer = AVSpeechSynthesizer()
    private var isPlaying = true
    private var soundImageName =  ""
    
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
        if speakerImage != nil {
            speakerTapGestureToImage()
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
    
    func speakerTapGestureToImage() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(speakerTapped))
        speakerImage.isUserInteractionEnabled = true
        speakerImage.addGestureRecognizer(tapGesture)
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
            // Announce the sound once screen is opened
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.playSound(with: self.Items[self.currentIndex].name)
            }
        } catch {
            print("Failed to load or parse JSON: \(error)")
        }
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
    
    // Step 5: Method called when right image is tapped
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
            //Play sound on click left
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if self.soundImageName == "pause.circle" {
                    self.playSound(with: self.Items[self.currentIndex].name)
                }
            }
        }
    }
    
    // Step 6: Method called when left image is tapped
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
        //Play sound on click left
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.soundImageName == "pause.circle" {
                self.playSound(with: self.Items[self.currentIndex].name)
            }
        }
    }
    
    @objc func doneButtonTapped() {
        self.dismiss(animated: true , completion: nil)
    }
    
    @objc func speakerTapped() {
        isPlaying.toggle() // Toggle play/pause state
        if isPlaying {
            if !speechSynthesizer.isSpeaking {
                self.playSound(with: self.Items[self.currentIndex].name)
            }  else {
                speechSynthesizer.continueSpeaking()
            }
        } else {
            pauseSound()
        }
        // Update the image based on the current state
        soundImageName = isPlaying ? "pause.circle" : "play.circle"
        speakerImage.image = UIImage(systemName: soundImageName)
    }
    
    func playSound(with soundString: String) {
        if !speechSynthesizer.isSpeaking {
            speak(word: soundString)
        } else {
            speak(word: soundString)
            speechSynthesizer.continueSpeaking()
        }
    }
    
    func pauseSound() {
        speechSynthesizer.pauseSpeaking(at: .immediate)
    }

    func speak(word: String) {
        // Create a speech utterance
        let wording = splitWords(speakingWord: word)
        let utterance = AVSpeechUtterance(string: wording)
        // Customize the utterance if needed
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.rate = 0.2 // Adjust to a slower rate (default is 0.5)
        utterance.pitchMultiplier = 1.0 // Normal pitch
        utterance.volume = 1.0 // Maximum volume
        // Speak the word
        speechSynthesizer.speak(utterance)
        //currentWord = word
    }
    
    func splitWords(speakingWord: String) ->  String {
        if speakingWord.count <= 1 {
            return speakingWord
        } else {
            let spacedString = speakingWord.map { String($0) + " " }.joined()
            return spacedString + speakingWord
        }
    }
    
}


