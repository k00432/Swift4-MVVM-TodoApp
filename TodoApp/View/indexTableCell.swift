//
//  TodoTableCell.swift
//  TodoApp
//
//  Created by k00432 on 25/12/2018.
//  Copyright © 2018 k00432. All rights reserved.
//

import UIKit

class IndexTableCell: UITableViewCell {
    /*------------------------------------------------var------------------------------------------------------*/
    var id:Int?;
    /*------------------------------------------------view------------------------------------------------------*/
    @IBOutlet var textButton: UILabel!
    /*------------------------------------------------funcs-----------------------------------------------------*/
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
