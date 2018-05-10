

import Foundation
import MBProgressHUD

extension MBProgressHUD {
    
    @discardableResult
    public class func showHUDAddedGlobal() -> MBProgressHUD?
    {
		if let window = UIApplication.shared.delegate?.window {
			MBProgressHUD.hide(for: window!, animated: false)
			let hud = MBProgressHUD.showAdded(to: window!, animated: true)
            hud?.activityIndicatorColor = UIColor.white
            hud?.animationType = MBProgressHUDAnimation.fade
            hud?.dimBackground = true

			return hud
		}
		return nil
	}
	
    public class func dismissGlobalHUD()
    {
        if let window = UIApplication.shared.delegate?.window {
            MBProgressHUD.hide(for: window!, animated: true)
        }

    }
}
