//
//  CommentChildCell.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 29/09/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit
import DropDown

class CommentChildCell: UICollectionViewCell {
    @IBOutlet var imgCommentUser : UIImageView!
     @IBOutlet var imgDownArrow : UIImageView!
       @IBOutlet var lblCommentName : UILabel!
        @IBOutlet var lbldate : UILabel!
       @IBOutlet var lblCommentDes : UILabel!
    @IBOutlet var btnDeletedView : UIButton!
    @IBOutlet var btnDeleted : UIButton!
     let DeleteRlyDropDown = DropDown()
     @IBOutlet var btnShowmore : UIButton!
    @IBOutlet var imgCommentUserImages : UIImageView!
       @IBOutlet var cnImagesViewHeight : NSLayoutConstraint!
    @IBOutlet var ViewPDF : UIView!
        @IBOutlet var lblPdfName : UILabel!
    var btnShowmoreClick: (( _ indexPath : IndexPath,_ value: Int)->())?
   var indexPath : IndexPath!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCellWith( indexPath1 : IndexPath)
    {
        indexPath = indexPath1
    }
    @IBAction func btnShowmoreAction(_ sender: AnyObject) {
        self.btnShowmoreClick?(self.indexPath,1)
    }
    @IBAction func DeleteComment(_ sender: AnyObject) {
           DeleteRlyDropDown.show()
       }
}


