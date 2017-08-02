//
//  InfoVC.swift
//  MorseString
//
//  Created by Anthony Benitez on 7/16/17.
//  Copyright © 2017 SymphoLife. All rights reserved.
//

import UIKit
import AVFoundation

class InfoVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var dictionaryTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dictionaryTable.delegate = self
        dictionaryTable.dataSource = self
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return morseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dictionaryTable.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfoCell
        cell.literalLabel.text = String(morseArray[indexPath.row])
        cell.morseLabel.text = String(describing: morseDictionary[morseArray[indexPath.row]]!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // declare audio path as the path of the resource
        let audioPath = Bundle.main.path(forResource: "morse_\(morseArray[indexPath.row])", ofType: "wav")
        
        do {
            // try declaring a player with the contents of the path and play it
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
            audioPlayer.play()
        } catch {
            // code when try fails
        }
    }
    
    @IBAction func toTranslate(_ sender: Any) {
        performSegue(withIdentifier: "toMain", sender: nil)
    }
    
}
