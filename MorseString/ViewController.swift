//
//  ViewController.swift
//  MorseString
//
//  Created by Anthony Benitez on 7/16/17.
//  Copyright © 2017 SymphoLife. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITextViewDelegate {

    var textToMorse = true
    var stringInput = ""
    var stringOutputText = ""
    var stringOutputMorse = ""

    let queuePlayer = AVQueuePlayer()
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var translateModeLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var textToTranslateInput: UITextView!
    @IBOutlet weak var translationOutput: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // textToTranslateInput.returnKeyType = UIReturnKeyType.done
        textToTranslateInput.delegate = self
        
        textToTranslateInput.layer.borderWidth = 1.0;
        textToTranslateInput.layer.cornerRadius = 5.0;
        
        translationOutput.layer.borderWidth = 1.0;
        translationOutput.layer.cornerRadius = 5.0;
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        
        if let in_1 = UserDefaults.standard.object(forKey: "in") as? String {
            stringInput = in_1
            textToTranslateInput.text = in_1
        }
        if let out_1 = UserDefaults.standard.object(forKey: "outMorse") as? String {
            stringOutputMorse = out_1
        }
        if let out_2 = UserDefaults.standard.object(forKey: "outText") as? String {
            stringOutputText = out_2
        }
        if let out_3 = UserDefaults.standard.object(forKey: "outLabel") as? String {
            translationOutput.text = out_3
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // When touching in the view area (not the keyboard)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Makes the keyboard close
        self.view.endEditing(true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func textOrMorseSwitched(_ sender: UISwitch) {
        if textToMorse {
            textToMorse = false
            translateModeLabel.text = "Translate: Morse to Text"
            instructionsLabel.text = "Each morse code should be separated by a space."
        } else {
            textToMorse = true
            translateModeLabel.text = "Translate: Text to Morse"
            instructionsLabel.text = "Supports roman letters and numbers from 0 to 9."
        }
    }
    
    @IBAction func translateInput(_ sender: UIButton) {
        
        // reset output containers
        stringOutputMorse = ""
        stringOutputText = ""
        
        stringInput = textToTranslateInput.text
        stringInput = stringInput.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if stringInput == "" {
            translationOutput.text = "Incompatible input."
            stringOutputMorse = ""
            stringOutputText = ""
            return
        }
        
        // TODO should handle non existing morse inputs (example: '+', '\', etc)
        if textToMorse {
            for i in 0...(Int(stringInput.characters.count) - 1) {
                
                let currentChar = stringInput[i].lowercased()
                guard let currentCharInDict = morseDictionary[currentChar] as String? else {
                    translationOutput.text = "Incompatible input."
                    stringOutputMorse = ""
                    stringOutputText = ""
                    return
                }
                stringOutputMorse = stringOutputMorse.trimmingCharacters(in: .whitespacesAndNewlines)
                stringOutputText = stringOutputText.trimmingCharacters(in: .whitespacesAndNewlines)
                stringOutputMorse += currentCharInDict
                stringOutputText += currentChar
            }
            translationOutput.text = stringOutputMorse
        } else {
            let stringInputArr = stringInput.components(separatedBy: " ")
            print(stringInputArr)
            for c in stringInputArr {
                if let char = textDictionary[c.lowercased()] {
                    stringOutputMorse += c
                    stringOutputText += char
                } else {
                    translationOutput.text = "Incompatible input."
                    stringOutputMorse = ""
                    stringOutputText = ""
                    return
                }
            }
            stringOutputMorse = stringOutputMorse.trimmingCharacters(in: .whitespacesAndNewlines)
            stringOutputText = stringOutputText.trimmingCharacters(in: .whitespacesAndNewlines)
            translationOutput.text = stringOutputText
            stringInput = stringOutputText
        }
        
        
         UserDefaults.standard.set(stringOutputMorse, forKey: "outMorse")
         UserDefaults.standard.set(stringOutputText, forKey: "outText")
         UserDefaults.standard.set(translationOutput.text, forKey: "outLabel")
         UserDefaults.standard.set(textToTranslateInput.text, forKey: "in")
    }
    
    
    @IBAction func playMorse(_ sender: UIButton) {
        if translationOutput.text != "" && translationOutput.text != "Incompatible input." {
            queuePlayer.removeAllItems()
            
            if stringInput != "" {
                for i in 0...(Int(stringInput.characters.count) - 1) {
                    var currentChar = stringInput[i].lowercased()
                    
                    if currentChar == " " {
                        currentChar = "space"
                    }
                    
                    // declare audio path as the path of the resource
                    let urlPath = Bundle.main.path(forResource: "morse_\(currentChar)", ofType:"wav")
                    let fileURL = URL(fileURLWithPath:urlPath!)
                    let playerItem = AVPlayerItem(url:fileURL)
                    queuePlayer.insert(playerItem, after: nil)
                }

            }
            
            // play with a slight pause between each one
            queuePlayer.playImmediately(atRate: 1.0005)
        }
    }
    
    @IBAction func toInfo(_ sender: Any) {
        queuePlayer.pause()
        queuePlayer.removeAllItems()
        performSegue(withIdentifier: "toInfo", sender: nil)
    }
    
    @IBAction func clearTextButtonPressed(_ sender: UIButton) {
        textToTranslateInput.text = ""
    }
    
    @IBAction func copyToClipboardButtonPressed(_ sender: Any) {
        UIPasteboard.general.string = translationOutput.text
        showToast(message: "Translation Copied")
    }
    
    
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return self[Range(start ..< end)]
    }
}

// Android Toast-like extension for the UIViewController
extension UIViewController {
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-100, width: 200, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }

