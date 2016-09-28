//
//  AffiliateListTableViewController.swift
//  Shingo Events
//
//  Created by Craig Blackburn on 2/1/16.
//  Copyright © 2016 Shingo Institute. All rights reserved.
//

import UIKit
import PureLayout

class AffiliateListTableViewController: UITableViewController {

    var affiliateSections:[(String, [SIAffiliate])]!
    
    lazy var sectionHeaders: [String] = {
        var headers = [String]()
        for section in self.affiliateSections {
            headers.append(section.0)
        }
        return headers
    }()
    
    lazy var affiliateDataSource: [[SIAffiliate]] = {
        var sections = [[SIAffiliate]]()
        for section in self.affiliateSections {
            sections.append(section.1)
        }
        return sections
    }()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        DispatchQueue.global().async {
            for section in self.affiliateSections {
                for affiliate in section.1 {
                    affiliate.isSelected = false
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 186
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if affiliateSections.isEmpty {
            let notification = UILabel.newAutoLayout()
            view.addSubview(notification)
            notification.autoPinEdge(.top, to: .top, of: view, withOffset: 50)
            notification.autoAlignAxis(toSuperviewAxis: .vertical)
            notification.text = "Content Not Available"
            notification.textColor = UIColor.white
            notification.sizeToFit()
        }
        
    }
    
}

extension AffiliateListTableViewController {
    
    // MARK: - TableView data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return affiliateSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return affiliateDataSource[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AffiliateCell", for: indexPath) as! AffiliateTableViewCell
        
        cell.affiliate = affiliateDataSource[indexPath.section][indexPath.row]
        
        cell.isExpanded = affiliateDataSource[indexPath.section][indexPath.row].isSelected
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AffiliateTableViewCell
        
        cell.isExpanded = !cell.isExpanded
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel(text: "  \(sectionHeaders[section].uppercased())", font: UIFont.preferredFont(forTextStyle: .headline))
        header.textColor = .white
        header.backgroundColor = .shingoRed
        return header
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
}


class AffiliateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var summaryTextView: UITextView! {
        didSet {
            summaryTextView.layer.shadowColor = UIColor.gray.cgColor
            summaryTextView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            summaryTextView.layer.shadowOpacity = 1
            summaryTextView.layer.shadowRadius = 3
            summaryTextView.layer.masksToBounds = false
            summaryTextView.layer.cornerRadius = 3
        }
    }
    
    var affiliate: SIAffiliate! {
        didSet {
            updateCell()
        }
    }
    
    var isExpanded = false {
        didSet {
            affiliate.isSelected = isExpanded
            if isExpanded {
                expandCell()
            } else {
                shrinkCell()
            }
        }
    }
    
    private func updateCell() {
        
        selectionStyle = .none
        
        if let affiliate = affiliate {
            
            nameLabel.text = affiliate.name
            
            affiliate.getLogoImage() { image in
                self.logoImageView.image = image
                
                let maxWidth = self.contentView.frame.width - 16
                
                if image.size.width > maxWidth {
                    self.logoImageView.resizeImageViewToIntrinsicContentSize(thatFitsWidth: maxWidth)
                }
            }
        }
    }
    
    let tapToSeeLessText = NSAttributedString(string: "\n\nTap To See Less...", attributes: [
        NSFontAttributeName : UIFont.preferredFont(forTextStyle: .footnote),
        NSForegroundColorAttributeName : UIColor.gray,
        NSParagraphStyleAttributeName : SIParagraphStyle.center
    ])
    
    let selectMoreInfoText = NSAttributedString(string: "Select For More Info >", attributes: [
        NSFontAttributeName : UIFont.preferredFont(forTextStyle: .footnote),
        NSForegroundColorAttributeName : UIColor.gray,
        NSParagraphStyleAttributeName : SIParagraphStyle.center
    ])
    
    private func expandCell() {
        
        let summary = NSMutableAttributedString(attributedString: affiliate.attributedSummary)
        
        if summary.string.isEmpty {
            summary.append( NSMutableAttributedString(string: "Check back later for more information."))
        }
  
        let summaryAttrs = [
            NSFontAttributeName : UIFont.preferredFont(forTextStyle: .body),
            NSParagraphStyleAttributeName : SIParagraphStyle.left,
            NSForegroundColorAttributeName : UIColor.black
        ]
        
        summary.addAttributes(summaryAttrs, range: summary.fullRange)
        
        
        
        summary.append(tapToSeeLessText)
        
        summaryTextView.attributedText = summary
        
    }
    
    private func shrinkCell() {
        
        
        
        summaryTextView.attributedText = selectMoreInfoText
    }

    
}
