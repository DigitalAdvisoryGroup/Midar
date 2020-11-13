//
//  SoicalMediaCell.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 27/08/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit
import Kingfisher
class SoicalMediaCell: UITableViewCell {
     @IBOutlet var lblDesc : UILabel!
     @IBOutlet var btnLike : UIButton!
     @IBOutlet var imgUser : UIImageView!
    @IBOutlet var lblname : UILabel!
    @IBOutlet var lbldate : UILabel!
    var objectDict = NSDictionary()
     var media_idsAry = [NSDictionary]()
        var indexPath : IndexPath!
        @IBOutlet var btncomment : UIButton!
      @IBOutlet var btndelete : UIButton!
    @IBOutlet var btnshare : UIButton!
    var btnDeleteCallBack: (( _ indexPath : IndexPath)->())?

    var btnLikeCallBack: (( _ indexPath : IndexPath,_ value: Int)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    func configureCellWith(viewController : UIViewController, indexPath1 : IndexPath,value: Int,object : NSDictionary)
    {
        
        indexPath = indexPath1
        lblname.text = "\(object["name"] ?? "")"
        lbldate.text = "Published by " + "\(object["post_owner"] ?? "") " + "\(object["date"] ?? "")"
        //BIT \(object["date"] ?? "")"
        lblDesc.text = "\(object["message"] ?? "")"
              lblDesc.numberOfLines = 0
               lblDesc.sizeToFit()
       
        let likedata = object.object(forKey: "like") as? Int
        if likedata == 0
        {
            btnLike.setImage(UIImage.init(named: "LikeUnread"), for: .normal)
                      // btnLike.setTitle(" Like", for: .normal)
        }
        else
        {
            btnLike.setImage(UIImage.init(named: "likeFiled"), for: .normal)
                    //   btnLike.setTitle(" Like", for: .normal)
        }
      
        
    }
    @IBAction func btnLikeTapped(_ sender : UIButton){
      //  let likeOrNone : E_LikeReaction = self.socialPostDetails.myLike != 0 ? .none : .like

        let likedata = objectDict.object(forKey: "like") as? Int
       // let likeOrNone : E_LikeReaction = self.socialPostDetails.myLike != 0 ? .none : .like
        //self.btnLikeCallBack?(self.socialPostDetails, E_LikeReaction.init(rawValue: self.socialPostDetails.myLike)!, likeOrNone, self.indexPath)
        self.btnLikeCallBack?(self.indexPath,likedata!)
    }
    @IBAction func btnDeleteTapped(_ sender : UIButton){

        self.btnDeleteCallBack?(self.indexPath)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
