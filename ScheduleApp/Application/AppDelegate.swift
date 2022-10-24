import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else {
            return false
        }

        window.rootViewController = SplashScreenViewController {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) {
                if AuthService.shared.currentUser == nil {
                    let wireframe = RegistrationScreenWireframe {
                        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) {
                            window.rootViewController = TabBar()
                        }
                    }
                    let nav = UINavigationController()
                    nav.setRootWireframe(wireframe)
                    window.rootViewController = nav
                } else {
                    window.rootViewController = TabBar()
                }
            }
        }
        window.makeKeyAndVisible()

        return true
    }

    func applicationDidBecomeActive(_: UIApplication) {
        NotificationCenter.default.post(.init(name: .AppDidBecomeActive))
    }
}

extension Notification.Name {
    static let AppDidBecomeActive = Notification.Name("applicationDidBecomeActiveNotification")
}
