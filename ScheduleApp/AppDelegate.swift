import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
		guard let window = window else {
			return false
		}

		let initialViewController = UINavigationController()
		initialViewController.setRootWireframe(
			SplashScreenWireframe {
				UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) {
					initialViewController.setRootWireframe(ScheduleScreenWireframe(), animated: false)
				}
			}
		)

        window.rootViewController = initialViewController
        window.makeKeyAndVisible()

        return true
    }

	func applicationDidBecomeActive(_ application: UIApplication) {
		NotificationCenter.default.post(.init(name: .AppDidBecomeActive))
	}
}

extension Notification.Name {
	static let AppDidBecomeActive = Notification.Name("applicationDidBecomeActiveNotification")
}
