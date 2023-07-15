//
//  WithdrawHistoryCell.swift
//  MyPiggy
//
//  Created by Noel Rosario on 12/11/22.
//

import UIKit

class WithdrawHistoryCell: UITableViewCell {

    @IBOutlet weak var withdrawamountLabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var remainingbalancelabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(history: History)
    {
        withdrawamountLabel.text = "$" + history.saveAmout
        datelabel.text = history.date
        remainingbalancelabel.text = "$" + history.totalBalance
        if history.isWithdrawl
        {
            withdrawamountLabel.textColor = .red
        }
        else
        {
            withdrawamountLabel.textColor = .white
        }
    }

}
