//
//  CampaginCell.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 01/10/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit
import Cosmos
class CampaginCell: UITableViewCell {
    @IBOutlet var imgUser : UIImageView!
     @IBOutlet var lblname : UILabel!
     @IBOutlet var lbldate : UILabel!
     @IBOutlet var lblRespo : UILabel!
    @IBOutlet var lbllike : UILabel!
    @IBOutlet var lblEmail : UILabel!
    @IBOutlet var lblPost : UILabel!
    @IBOutlet var lblrating : UILabel!
    @IBOutlet var lblAvgratings : UILabel!
     @IBOutlet var lblMyratings : UILabel!
     @IBOutlet var btnresponsible : UIButton!
  //  rating_count
     @IBOutlet var lblAvgratingstitle : UILabel!
     @IBOutlet var lblMyratingstitle : UILabel!
     @IBOutlet weak var viewAVgRating: CosmosView!
     @IBOutlet weak var viewMyRating: CosmosView!
    
     var viewController = UIViewController()
    override func awakeFromNib() {
        super.awakeFromNib()
        lblAvgratingstitle.text = "Average Rating".localized()
        lblMyratingstitle.text = "My Rating".localized()
        lblRespo.text = "Responsible".localized()
        lblAvgratingstitle.numberOfLines = 0
        lblAvgratingstitle.sizeToFit()
        // Initialization code
    }

    func configureCellWith(viewController : UIViewController, indexPath1 : IndexPath,object : NSDictionary)
    {
         self.viewController = viewController
        btnresponsible.setTitle("\(object["responsible"] ?? "")", for: .normal)
      
        let like = "\(object["like_count"] ?? 0) " + "Likes".localized() + "\n"
        let dislike = "\(object["dislike_count"] ?? 0) " + "Dislike".localized() + "\n"
        let commentCount = "\(object["comments_count"] ?? 0) " + "Comments".localized() + "\n"
        let share = "\(object["shares_count"] ?? 0) " + "Sharings".localized() + "\n"
            
         lbllike.text = "\(like)" + "\(dislike)" + "\(commentCount)" + "\(share)"
                 
                 lbllike.numberOfLines = 0
                 
                  lbllike.sizeToFit()
        
        lblEmail.text = "\(object["mailing_count"] ?? 0) " + "Mailings".localized()
        lblPost.text = "\(object["post_count"] ?? 0) " + "Posts".localized()
        
        lblrating.text = "\(object["rating_count"] ?? 0) " + "Ratings".localized()
        
        lblAvgratings.text = "\(object["avg_rating"] ?? 0)"
        
        viewAVgRating.settings.fillMode = .precise
                     viewAVgRating.rating = (object["avg_rating"] as? Double)!
        lblMyratings.text = "\(object["my_rating"] ?? 0)"
        
               viewMyRating.settings.fillMode = .precise
                            viewMyRating.rating = (object["my_rating"] as? Double)!
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
