import GradientLoadingBar
import SPIndicator
import UIKit

protocol WireframeInterface: AnyObject {
    func showAlert(title: String, message: String?, preset: SPIndicatorIconPreset, presentSide: SPIndicatorPresentSide)
    func showLoadingBar()
    func hideLoadingBar()
}

class BaseWireframe<ViewController> where ViewController: UIViewController {
    private unowned var _viewController: ViewController

    // We need it in order to retain the view controller reference upon first access
    private var temporaryStoredViewController: ViewController?

    init(viewController: ViewController) {
        temporaryStoredViewController = viewController
        _viewController = viewController
    }
}

extension BaseWireframe: WireframeInterface {
    func showAlert(title: String, message: String?, preset: SPIndicatorIconPreset, presentSide: SPIndicatorPresentSide) {
        DispatchQueue.main.async {
            SPIndicator.present(title: title, message: message, preset: preset, from: presentSide)
        }
    }

    func showLoadingBar() {
        DispatchQueue.main.async {
            GradientLoadingBar.shared.fadeIn()
        }
    }

    func hideLoadingBar() {
        DispatchQueue.main.async {
            GradientLoadingBar.shared.fadeOut()
        }
    }
}

extension BaseWireframe {
    var viewController: ViewController {
        defer { temporaryStoredViewController = nil }
        return _viewController
    }

    var navigationController: UINavigationController? {
        viewController.navigationController
    }
}

extension UIViewController {
    func presentWireframe<ViewController>(_ wireframe: BaseWireframe<ViewController>,
                                          animated: Bool = true, completion: (() -> Void)? = nil)
    {
        DispatchQueue.main.async {
            self.present(wireframe.viewController, animated: animated, completion: completion)
        }
    }
}

extension UINavigationController {
    func pushWireframe<ViewController>(_ wireframe: BaseWireframe<ViewController>, animated: Bool = true) {
        DispatchQueue.main.async {
            self.pushViewController(wireframe.viewController, animated: animated)
        }
    }

    func setRootWireframe<ViewController>(_ wireframe: BaseWireframe<ViewController>, animated: Bool = true) {
        DispatchQueue.main.async {
            self.setViewControllers([wireframe.viewController], animated: animated)
        }
    }
}

private extension GradientLoadingBar {
    static let shared = GradientLoadingBar(height: Constants.loadingBarHeight,
                                           isRelativeToSafeArea: true)
}
