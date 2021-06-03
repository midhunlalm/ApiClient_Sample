//
//  SearchResultCell.swift
//  DayToDayWiki
//
//  Created by Midhunlal on 24/11/20.
//

import UIKit

class SearchResultCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configure(item: PageItem?) {
        guard let item = item else { return }
        titleLabel.text = item.title
        itemImageView.setImageFromUrl(item.thumbnail?.imageUrl)
    }
}
