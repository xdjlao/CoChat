import UIKit
struct Theme {
    enum Colors {
        case BackgroundColor
        case DarkBackgroundColor
        case NavigationBarColor
        case ForegroundColor
        case ButtonColor
        case DarkButtonColor
        case RedButtonColor
        case TransparentLabelColor
        
        var color: UIColor{
            switch self {
            case .BackgroundColor: return UIColor(r: 63, g: 81, b: 181)
            case .DarkBackgroundColor: return UIColor(r: 48, g: 63, b: 159)
            case .NavigationBarColor: return UIColor(r: 26, g: 35, b: 126)
            case .ForegroundColor: return UIColor(r: 121, g: 134, b: 203)
            case .ButtonColor: return UIColor(r: 0, g: 227, b: 205) // bright blue
            case .DarkButtonColor: return UIColor(r: 51, g: 153, b: 255)
            case .RedButtonColor: return UIColor(r: 255, g: 51, b: 51)
            case .TransparentLabelColor: return UIColor(red: 121/255, green: 134/255, blue: 203/255, alpha: 0.3)
            }
        }
    }
    
//    enum BoldColor: UInt32 {
//        case RedColor = 0
//        case BlueColor = 1
//        case YellowColor = 2
//        case GreenColor = 3
//        case PinkColor = 4
//        case PurpleColor = 5
//        case OrangeColor = 6
//        
//        static let allValues = [RedColor, BlueColor, YellowColor, GreenColor, PinkColor, PurpleColor, OrangeColor]
//        
//        var color: UIColor {
//            switch self {
//            case .RedColor: return UIColor(r:255, g: 51, b: 51)
//            case .YellowColor: return UIColor(r: 255, g: 255, b: 51)
//            case .GreenColor: return UIColor(r: 51, g: 255, b: 51)
//            case .PinkColor: return UIColor(r: 255, g: 51, b: 255)
//            case .PurpleColor: return UIColor(r: 155, g: 51, b: 255)
//            case .OrangeColor: return UIColor(r: 255, g: 155, b: 51)
//            }
//        }
//    }
    
    
//    static func randomColor() -> NeonColor {
//        let maxValue = NeonColor.OrangeColor.rawValue
//        let randomValue = arc4random_uniform(maxValue)
//        return NeonColor(rawValue: randomValue)!
//    }
    
    
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
