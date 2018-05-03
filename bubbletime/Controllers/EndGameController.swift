//
//  EndGameController.swift
//  pongagon-2
//
//  Created by Jonathan Moallem on 2/5/18.
//  Copyright © 2018 Sudo-Code Software. All rights reserved.
//

import UIKit

class EndGameController: UIViewController, UITableViewDataSource, UITableViewDelegate, AlertDelegate {
    
    // Fields
    var playerScore: PlayerScore?
    
    // Outlet fields
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var highScores: [PlayerScore] = [PlayerScore(name: "Shoshi", score: 10), PlayerScore(name: "Shoshana", score: 8), PlayerScore(name: "Toblo", score: 5), PlayerScore(name: "Shoshtakovic", score: 0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let ps: PlayerScore = playerScore else {
            return
        }
        
        highScores.append(ps)
        
        highScores.sort(by: { $0.score > $1.score })
        
        // Set the score label
        scoreLabel.text = "Final Score: \(ps.score)"
        
        // Set up the table view for callbacks
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let alertHelper = AlertHelper(withText: "Save Score", and: "Enter your name")
        alertHelper.delegate = self
        alertHelper.addTextField(for: "Name")
        alertHelper.displayAlert(for: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerScoreCell", for: indexPath)
        
        let l: UILabel = cell.viewWithTag(2) as! UILabel
        let s: UILabel = cell.viewWithTag(3) as! UILabel
        l.text = " \(indexPath.row + 1). \(highScores[indexPath.row].name)"
        s.text = "\(highScores[indexPath.row].score) points"
        
        if indexPath.row % 2 == 1 {
            cell.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.1)
        }
        return cell
    }
    
    func onSubmit(text: String?) {
        print(text!)
    }
    
    func onCancelAction() {
        print("Cancelled")
    }
    
}
