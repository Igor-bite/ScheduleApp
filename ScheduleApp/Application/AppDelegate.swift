#if DEBUG
import Atlantis
#endif
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

        NotificationCenter.default.addObserver(self, selector: #selector(showAuthScreen), name: .WantToLogOut, object: nil)

        window.rootViewController = SplashScreenViewController {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) {
                if AuthService.shared.currentUser == nil {
                    let wireframe = AuthScreenWireframe {
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

#if DEBUG
        Atlantis.start()
#endif

        return true
    }

    @objc
    private func showAuthScreen() {
        guard let window = window else { return }
        let wireframe = AuthScreenWireframe {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) {
                window.rootViewController = TabBar()
            }
        }
        let nav = UINavigationController()
        nav.setRootWireframe(wireframe)
        window.rootViewController = nav
    }

    func applicationDidBecomeActive(_: UIApplication) {
        NotificationCenter.default.post(.init(name: .AppDidBecomeActive))
    }
}

extension Notification.Name {
    static let AppDidBecomeActive = Notification.Name("applicationDidBecomeActiveNotification")
    static let WantToLogOut = Notification.Name(rawValue: "wantsToLogOut")
}
