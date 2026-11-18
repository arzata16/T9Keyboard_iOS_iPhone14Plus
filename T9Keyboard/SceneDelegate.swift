import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let win = UIWindow(windowScene: windowScene)
        let mainVC = ViewController()
        let nav = UINavigationController(rootViewController: mainVC)
        nav.navigationBar.prefersLargeTitles = true
        win.rootViewController = nav
        self.window = win
        win.makeKeyAndVisible()
    }
}
