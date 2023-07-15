//
//  GoalListCell.swift
//  MyPiggy
//
//  Created by Noel Rosario on 12/11/22.
//

import UIKit

var basicpiggyImage = UIImage(named: "basicPiggy")
var custompiggyImage = UIImage(named: "customPig")
var brokenPiggyImage = UIImage(named: "broken")

class GoalListCell: UITableViewCell {
    
    @IBOutlet weak var goalname: UILabel!
    @IBOutlet weak var goalimageview: UIImageView!
    @IBOutlet weak var goalamount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func setData(goal : Goal) {
        //assign goal values from passed in goal obj
        goalname.text = goal.goalName
        goalamount.text = "$" + String(goal.totalAmountCollected)
        if goal.goalType == .basic
        {
            self.goalimageview.image = basicpiggyImage
        }
        else if goal.goalType == .custom
        {
            self.goalimageview.image = custompiggyImage
        }
        else 
        {
            self.goalimageview.image = brokenPiggyImage
        }
    }


}
