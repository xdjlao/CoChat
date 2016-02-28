import UIKit
struct Theme {
    enum Colors {
        case BackgroundColor
        case DarkBackgroundColor
        case NavigationBarColor
        case ForegroundColor
        case ButtonColor
        
        //based off of google material design color pallete
        
//        var tealColor: UIColor {
//            switch self {
//            case .BackgroundColor: return UIColor(r: 0, g: 150, b: 136) //500
//            case .DarkBackgroundColor: return UIColor(r: 0, g: 77, b: 64) //900
//            case .NavigationBarColor: return UIColor(r: 0, g: 121, b: 107) //700
//            case .ForegroundColor: return UIColor(r: 77, g: 182, b: 172) //300
//            case .ButtonColor: return UIColor(r: 0, g: 227, b: 205) //green 500
//            }
//        }
        
        var color: UIColor{
            switch self {
            case .BackgroundColor: return UIColor(r: 63, g: 81, b: 181)
            case .DarkBackgroundColor: return UIColor(r: 48, g: 63, b: 159)
            case .NavigationBarColor: return UIColor(r: 26, g: 35, b: 126)
            case .ForegroundColor: return UIColor(r: 121, g: 134, b: 203)
            case .ButtonColor: return UIColor(r: 0, g: 227, b: 205) // bright green
            }
        }
        
//        var redColor: UIColor {
//            switch self {
//            case .BackgroundColor: return UIColor(r: 244, g: 67, b: 54)
//            case .DarkBackgroundColor: return UIColor(r: 183, g: 28, b: 28)
//            case .NavigationBarColor: return UIColor(r: 211, g: 47, b: 47)
//            case .ForegroundColor: return UIColor(r: 229, g: 115, b: 115)
//            case .ButtonColor: return UIColor(r: 0, g: 150, b: 136) // indigo 500
//            }
//        }
    }



    enum Fonts {
        case TitleTypeFace
        case BoldTitleTypeFace
        case NormalTypeFace
        case LightNormalTypeFace
        case BoldNormalTypeFace
        case SubTitleTypeFace
        
        var font: UIFont {
            switch self{
            case .TitleTypeFace: return UIFont(name: "Lato-Medium", size: 18)!
            case .BoldTitleTypeFace: return UIFont(name: "Lato-Heavy", size: 17)!
            case .NormalTypeFace: return UIFont(name: "Lato-Light", size: 18)!
            case .LightNormalTypeFace: return UIFont(name: "Lato-Thin", size: 16)!
            case .BoldNormalTypeFace: return UIFont(name: "Lato-Regular", size: 16)!
            case .SubTitleTypeFace: return UIFont(name: "Lato-Hairline", size: 16)!
            }
        }
    }
}