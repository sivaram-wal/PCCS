

import UIKit


extension UIImageView {
    
    func setImageWithAnimation(_ image: UIImage) {
        CATransaction.begin()
        
        let transition = CATransition()
        transition.type = kCATransitionFade

        self.layer.add(transition, forKey: kCATransition)
        self.image = image
        
        CATransaction.commit()
//        CATransaction.finalize()
    }
}

extension UIImage {
    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
