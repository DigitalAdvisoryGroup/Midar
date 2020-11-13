//
//  Constatns.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 25/08/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//


import UIKit


let USERDEFAULTS        = UserDefaults.standard //UserDefault
let APPDELEGATE         = UIApplication.shared.delegate as! AppDelegate //AppDelegate
@available(iOS 13.0, *)
let SCENEDELEGATE         = UIApplication.shared.delegate as! SceneDelegate //AppDelegate
let SCREEN_SIZE         = UIScreen.main.bounds.size
let KMENUICONCOLOR      =  UIColor(red: 89/255.0, green: 90/255.0, blue: 92/255.0, alpha: 1.0)

class Constants: NSObject {
    
 
    
  
    
}

#if Kodavas
    let KTHEMECOLOR   = UIColor(red: 175/255.0, green: 1/255.0, blue: 28/255.0, alpha: 1.0)
#elseif Keraliam
    //let KTHEMECOLOR = UIColor(red: 175/255.0, green: 1/255.0, blue: 28/255.0, alpha: 1.0)
    let KTHEMECOLOR   = UIColor(red: 255/255.0, green: 179/255.0, blue: 0/255.0, alpha: 1.0)
#endif

let KREDTHEMECOLOR = UIColor(red: 175/255.0, green: 1/255.0, blue: 28/255.0, alpha: 1.0)
let KYELLOWTHEMECOLOR = UIColor(red: 255/255.0, green: 179/255.0, blue: 0/255.0, alpha: 1.0)

//Localization Language
struct LocaleLanguage {
    static let english                      = "en"
    static let hindi                        = "hi"
}
enum LocaleLanguageDisplay : String{
    case en = "English"
    case hi = "Hindi"
    
    static var values : [LocaleLanguageDisplay] {
        return [
            .en,
            .hi
        ]
    }
}

struct STORYBOARD {
static let AUTHENTICATION : UIStoryboard = UIStoryboard(name: "Authentications", bundle:nil)
static let HOME : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
    static let Main : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    static let Launch : UIStoryboard = UIStoryboard(name: "LaunchScreen", bundle:nil)
    
}



//MARK: - Date Formate
struct DATEFORMATE {
    //Only Date
    static let USA                  = "MM/dd/yy"
    static let US_DATE              = "MMM dd, yyyy"
    static let WEBSERVICEFORMDATE   = "yyyy-MM-dd"
    static let US_DATE_DAY          = "E, MMM dd, yyyy"
    static let DEFAULTFORDISPLAY    = "yyyy-MM-dd"
    static let DAY_DATE             = "E, dd, MMM"
    static let DAY_DATE_FULLMONTH   = "E, dd, MMMM"
    static let FULLDAY_DATE         = "EEEE, dd, MMMM"
    static let DD_MM_YYYY           = "dd-MM-yyyy"
    
    //Date Time
    static let DEFAULTFORWS         = "yyyy-MM-dd HH:mm"
    static let FULLDATE12TIME       = "yyyy-MM-dd hh:mm a"
    static let WEBSERVICEFORMDATETIME   = "yyyy-MM-dd HH:mm:ss"
    static let US                   = "MMM dd, yyyy HH:mm"
    static let US_12HOUR            = "MMM dd, yyyy • hh:mm a"
    
    //Only Time
    static let HOUR12               = "hh:mm a"
    static let HOUR24               = "HH:mm"
    
}



//MARK: - Storyboard/ View Controller

//struct STORYBOARD {
//    
//    static let HOME : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
//   
//}

struct StoryboardId {
    
    static let HOME                 = "Home"
    static let MAIN                 = "Main"
   
}

struct NIB {
    static let MEETINGTBLCELL       = "MeetingTblCell"
}

//View Controller ID
struct VCId {
    
}

//Custom Cell ID
struct CellId {}

//Segue identifiers
struct Segue {
    
}

//MARK: - Other
struct OtherConstant {
    static let forgetpassword       = "forgetpassword"
    static let editprofile          = "editprofile"
    static let Language             = "Language"
    static let Version              = "Version"
       
}

//Meeting Status
enum MeetingStatus : String{
    case FORWARDED = "FORWARDED"
    case COMPLETED = "COMPLETED"
    case REJECTED = "REJECTED"
    case EXPIRED = "EXPIRED"
    case CANCELLED = "CANCELLED"
    case SCHEDULED = "SCHEDULED"
    case PENDING = "PENDING"
    
    static var values : [MeetingStatus] {
        return [
            .FORWARDED,
            .COMPLETED,
            .REJECTED,
            .EXPIRED,
            .CANCELLED,
            .SCHEDULED,
            .PENDING
        ]
    }
}


enum LOGIN_TYPE_BY : Int{
    case Normal = 0
    case Facebook
    case Google
}

//Firabse Constants
struct ConstFireBase {
    
    //ALL FIrst Level Keys
    #if Kodavas
        static let DBKEY_Profile                = "Profile"
        static let DBKEY_Channel                = "Channel"
        static let DBKEY_Message                = "Message"
        static let DBKEY_Group                  = "Group"
    #elseif Keraliam
        static let DBKEY_Profile                = "Malayalam/Profile"
        static let DBKEY_Channel                = "Malayalam/Channel"
        static let DBKEY_Message                = "Malayalam/Message"
        static let DBKEY_Group                  = "Malayalam/Group"
    #endif
}
