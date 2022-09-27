import BrazeKit
import UIKit

/// The requirements for a view displayed by ``BrazeInAppMessageUI``.
///
/// BrazeUI ships with the following in-app message views:
/// - ``BrazeInAppMessageUI/SlideupView``
/// - ``BrazeInAppMessageUI/ModalView``
/// - ``BrazeInAppMessageUI/ModalImageView``
/// - ``BrazeInAppMessageUI/FullView``
/// - ``BrazeInAppMessageUI/FullImageView``
/// - ``BrazeInAppMessageUI/HtmlView``
/// - ``BrazeInAppMessageUI/ControlView``
///
/// Custom in-app message views must conform to this protocol.
public protocol InAppMessageView: UIView {

  /// The current presented state — is the message view visible to the user.
  var presented: Bool { get }

  /// Presents the message view to the user.
  ///
  /// When this method is called, the message view is already added to the view hierarchy.
  ///
  /// As part of its presentation, the in-app message view must report lifecycle events using:
  /// - ``willPresent()``: before any presentation animation occurs.
  /// - ``didPresent()``: after all presentation animations are completed and the message view is
  ///                     fully visible to the user.
  ///
  /// Additionally, the in-app message must also report analytics and click actions using:
  /// - ``logImpression()``: as soon as the message is fully visible to the user.
  /// - ``logClick(buttonId:):``: as the result of a user click.
  ///
  /// - Parameters:
  ///   - completion: The completion block executed once the message view is fully visible to the
  ///                 user.
  func present(completion: (() -> Void)?)

  /// Dimisses the message view.
  ///
  /// As part of its dismissal, the in-app message view must reports lifecycle events using the
  /// following methods:
  /// - ``willDismiss()``: before any dismissal animation occurs.
  /// - ``didDismiss()``: after all dismissal animations are completed and the message view is fully
  ///                     hidden from the user.
  ///
  /// - Parameter completion: The completion block executed once the message view is fully hidden
  ///                         from the user.
  func dismiss(completion: (() -> Void)?)

}

extension InAppMessageView {

  /// The preferred status bar hidden state.
  ///
  /// Setting this value may have no effect depending of upstream customizations.
  public var prefersStatusBarHidden: Bool? {
    get { controller?.messageViewPrefersStatusBarHidden }
    set { controller?.messageViewPrefersStatusBarHidden = newValue }
  }

  /// Call this method to report the "will present" event before any presentation animation occurs.
  public func willPresent() {
    guard let controller = controller, let ui = controller.ui else {
      return
    }

    ui.delegate?.inAppMessage(ui, willPresent: controller.message, view: self)
  }

  /// Call this method to report the "did present" event after all presentation animations are
  /// completed and the message view is fully visible to the user.
  public func didPresent() {
    guard let controller = controller, let ui = controller.ui else {
      return
    }

    ui.delegate?.inAppMessage(ui, didPresent: controller.message, view: self)
  }

  /// Call this method to report the "will dismiss" event before any dismissal animation occurs.
  public func willDismiss() {
    guard let controller = controller, let ui = controller.ui else {
      return
    }

    ui.delegate?.inAppMessage(ui, willDismiss: controller.message, view: self)
  }

  /// Call this method to report the "did dismiss" event after all dismissal animations are
  /// completed and the message view is fully hidden from the user.
  public func didDismiss() {
    guard let controller = controller, let ui = controller.ui else {
      return
    }

    ui.dismissTimer?.invalidate()
    ui.dismissTimer = nil

    removeFromSuperview()

    if #available(iOS 13.0, *) {
      ui.window?.windowScene = nil
    }
    ui.window = nil

    Braze.UIUtils.activeTopmostViewController?.setNeedsStatusBarAppearanceUpdate()

    ui.delegate?.inAppMessage(ui, didDismiss: controller.message, view: self)
  }

  /// Call this method to report the in-app message impression.
  public func logImpression() {
    guard let context = controller?.message.context else {
      logError(.noContextLogImpression)
      return
    }
    context.logImpression()
  }

  /// Call this method to report the in-app message click.
  /// - Parameter buttonId: An optional button identifier.
  public func logClick(buttonId: String? = nil) {
    guard let context = controller?.message.context else {
      logError(.noContextLogClick)
      return
    }
    context.logClick(buttonId: buttonId)
  }

  /// Call this method to process the in-app message click action.
  /// - Parameters:
  ///   - clickAction: The click action to process.
  ///   - buttonId: An optional button identifier.
  public func process(clickAction: Braze.InAppMessage.ClickAction, buttonId: String? = nil) {
    guard let ui = controller?.ui, let message = controller?.message else {
      return
    }

    let process =
      ui.delegate?.inAppMessage(
        ui,
        shouldProcess: clickAction,
        buttonId: buttonId,
        message: message,
        view: self
      ) ?? true

    guard process else { return }
    guard let context = message.context else {
      logError(.noContextProcessClickAction)
      return
    }

    context.processClickAction(clickAction)
  }

  public func logError(_ error: BrazeInAppMessageUI.Error) {
    controller?.message.context?.logError(flattened: error.logDescription)
      ?? print("[BrazeUI]", error.logDescription)
  }

  /// The controller currently displaying the in-app message view.
  public var controller: BrazeInAppMessageUI.ViewController? {
    responders
      .lazy
      .compactMap { $0 as? BrazeInAppMessageUI.ViewController }
      .first
  }

  /// Makes the in-app message view window become the first responder.
  ///
  /// Use this methods to properly dismiss the keyboard if needed. When the message view is
  /// dismissed, the keyboard original state is restored automatically by UIKit.
  public func makeKey() {
    window?.makeKey()
  }

  /// Specifies whether the UI is being displayed with both regular size classes in landscape.
  public var isLargeLandscape: Bool {
    guard let parentSize = controller?.view.bounds.size else { return false }
    return traitCollection.horizontalSizeClass == .regular
      && traitCollection.verticalSizeClass == .regular
      && parentSize.width > parentSize.height
  }

}
