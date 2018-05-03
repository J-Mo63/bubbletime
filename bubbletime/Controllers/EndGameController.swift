//
//  EndGameController.swift
//  pongagon-2
//
//  Created by Jonathan Moallem on 2/5/18.
//  Copyright © 2018 Sudo-Code Software. All rights reserved.
//

import UIKit

class EndGameController: UIViewController, UITableViewDataSource, UITableViewDelegate, AlertDelegate {
    
    // Constants
    let maxDisplayScores = 10
    
    // Fields
    var finalScore: Int!
    let storageManager: StorageManager = StorageManager()
    var scores: [PlayerScore] = []
    
    // Outlet fields
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load and sort scores
        do {
            scores = try storageManager.loadScores()
        }
        catch {
            handleError()
        }
        sortScores()
        
        // Set the score label
        scoreLabel.text = "Final Score: \(Int(finalScore))"
        
        // Set up the table view for callbacks
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Display the save score alert
        var alertHelper = AlertHelper(withText: "Save Score", and: "Enter your name to save it to the scores list")
        alertHelper.delegate = self
        alertHelper.addTextField(for: "Name")
        alertHelper.displayAlert(for: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maxDisplayScores
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Setup the cell as reusable
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerScoreCell", for: indexPath)
        
        // Get and set the labels
        let l: UILabel = cell.viewWithTag(2) as! UILabel
        let s: UILabel = cell.viewWithTag(3) as! UILabel
        l.text = " \(indexPath.row + 1). \(scores[indexPath.row].name)"
        s.text = "\(scores[indexPath.row].score) points"
        
        // Make the background colour alternate
        if indexPath.row % 2 == 1 {
            cell.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.1)
        }
        else {
            cell.backgroundColor = UIColor.clear
        }
        return cell
    }
    
    func onSubmit(text: String?) {
        // Create the player score
        let playerScore = PlayerScore(name: text!, score: finalScore)
        
        // Append it, sort it and reload the tableview
        scores.append(playerScore)
        sortScores()
        tableView.reloadData()
        
        // Save scores to the database
        do {
            try storageManager.save(scores: scores)
        }
        catch {
            handleError()
        }
    }
    
    func onCancelAction() {
        // Do nothing
    }
    
    func sortScores() {
        scores.sort(by: { $0.score > $1.score })
    }
    
    func handleError() {
        print("Handling error")
    }
}
