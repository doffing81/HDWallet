// TabBarVC.swift

import UIKit
import SpriteKit

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barStyle = .black
        tabBar.isTranslucent = false
        if UserDefaults.standard.bool(forKey: "testnet") == true {
            tabBar.tintColor = .green
        } else {
            tabBar.tintColor = #colorLiteral(red: 0.9693624377, green: 0.5771938562, blue: 0.1013594046, alpha: 1)
            addNavBarImage()
        }
        
        let receiveVC = ReceiveVC()
        receiveVC.tabBarItem = UITabBarItem(title: "Receive", image: UIImage(named: "receiveIcon"), tag: 0)
        let sendVC = SendVC()
        sendVC.view.backgroundColor = .lightGray
        sendVC.tabBarItem = UITabBarItem(title: "Send", image: UIImage(named: "sendIcon"), tag: 1)
        let transactionsVC = TransactionsVC()
        transactionsVC.view.backgroundColor = .darkGray
        transactionsVC.tabBarItem = UITabBarItem(title: "Transactions", image: UIImage(named: "bitcoinIcon"), tag: 2)
        let settingsVC = SettingsVC()
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settingsIcon"), tag: 3)
        
        let viewControllerList = [receiveVC, sendVC, transactionsVC, settingsVC]
        self.viewControllers = viewControllerList
    }
    
    private func addNavBarImage() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 153, height: 32))
        let image = UIImage(named: "BTCLogo")
        let imageView = UIImageView(image: image)
        // Nav bar height is 44, image height is 32, so -6 offset to center
        imageView.frame = CGRect(x: 0, y: -6, width: 153, height: 32)
        containerView.addSubview(imageView)
        navigationItem.titleView = containerView
    }
}
