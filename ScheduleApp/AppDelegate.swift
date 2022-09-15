import UIKit
import Core

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
		guard let window = window else {
			return false
		}

		let initialViewController = UINavigationController()
		initialViewController.setRootWireframe(MainScreenWireframe())

        window.rootViewController = initialViewController
        window.makeKeyAndVisible()

        return true
    }
}
