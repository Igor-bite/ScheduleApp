import GradientLoadingBar
import SPIndicator
import UIKit

public protocol WireframeInterface: AnyObject {
    func showAlert(title: String, message: String?, preset: SPIndicatorIconPreset, presentSide: SPIndicatorPresentSide)
    func showLoadingBar()
    func hideLoadingBar()
}

public class BaseWireframe<ViewController> where ViewController: UIViewController {
    private unowned var _viewController: ViewController

    // We need it in order to retain the view controller reference upon first access
    private var temporaryStoredViewController: ViewController?

    init(viewController: ViewController) {
        temporaryStoredViewController = viewController
        _viewController = viewController
    }
}

extension BaseWireframe: WireframeInterface {
    public func showAlert(title: String, message: String?, preset: SPIndicatorIconPreset, presentSide: SPIndicatorPresentSide) {
        DispatchQueue.main.async {
            SPIndicator.present(title: title, message: message, preset: preset, from: presentSide)
        }
    }

    public func showLoadingBar() {
        DispatchQueue.main.async {
            GradientLoadingBar.shared.fadeIn()
        }
    }

    public func hideLoadingBar() {
        DispatchQueue.main.async {
            GradientLoadingBar.shared.fadeOut()
        }
    }
}

public extension BaseWireframe {
    var viewController: ViewController {
        defer { temporaryStoredViewController = nil }
        return _viewController
    }

    var navigationController: UINavigationController? {
        viewController.navigationController
    }
}

public extension UIViewController {
    func presentWireframe<ViewController>(_ wireframe: BaseWireframe<ViewController>,
                                          animated: Bool = true, completion: (() -> Void)? = nil)
    {
        present(wireframe.viewController, animated: animated, completion: completion)
    }
}

public extension UINavigationController {
    func pushWireframe<ViewController>(_ wireframe: BaseWireframe<ViewController>, animated: Bool = true) {
        pushViewController(wireframe.viewController, animated: animated)
    }

    func setRootWireframe<ViewController>(_ wireframe: BaseWireframe<ViewController>, animated: Bool = true) {
        setViewControllers([wireframe.viewController], animated: animated)
    }
}

private extension GradientLoadingBar {
    static let shared = GradientLoadingBar(height: Constants.loadingBarHeight,
                                           isRelativeToSafeArea: true)
}
