## 6.6.1

##### Fixed
- Fixes a crash in the geofences feature that could occur when the number of monitored regions exceeded the maximum count.
- Fixes an issue introduced in `6.3.1` that would always update a user's push subscription status to `optedIn` on app launch if push permissions were authorized on the device settings.
  - The SDK now will only send the subscription status at app launch if the device notification settings goes from denied to authorized.
- `Braze.ContentCard.logClick(using braze: Braze)` will now log a click regardless of whether the `ContentCard` has a `ClickAction`.
  - This behavior differs from the default API `Braze.ContentCard.Context.logClick()`, which has the safeguard of requiring a `ClickAction` to log a click.

## 6.6.0

##### Fixed
- Fixes an issue in HTML in-app messages where custom event and purchase properties would always convert values for `1` and `0` to become `true` and `false`, respectively.
  - These property values will now respect their original form in the HTML.
- Prevents the default Braze UI from displaying in-app messages underneath the keyboard when Stage Manager is in use.

##### Added
- Adds the [`Braze.FeatureFlags.logFeatureFlagImpression(id: String)`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/featureflags-swift.class/logfeatureflagimpression(id:)) method.
- Adds the optional `merge` parameter to the Objective-C representation of the [`setCustomAttribute(key:dictionary:merge:)`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/user-swift.class/setcustomattribute(key:dictionary:merge:fileid:line:)) method.

## 6.5.0

##### Fixed
- Content card impressions can now be logged any number of times on a single card, bringing parity with Android and Web.
  - This removes the limit introduced in 6.3.1 where a card impression could only be logged once per session.
  - In the Braze-provided Content Cards feed UI, impressions will be logged once per feed instance.

##### Added
- Adds a simplified method for integrating push notification support into your application:
  - Automatic push integration can be enabled by setting `configuration.push.automation = true` on your configuration object.
    - This eliminates the need for the manual push integration outlined in the [_Implement the push notification handlers manually_](https://braze-inc.github.io/braze-swift-sdk/tutorials/braze/b1-standard-push-notifications#Option-2-Implement-the-push-notification-handlers-manually) tutorial section.
    - When enabled, the SDK will automatically implement the necessary system delegate methods for handling push notifications.
    - Compatibility with other push providers, whether first or third party, is maintained. The SDK will automatically handle only Braze push notifications, while original system delegate methods will be executed for all other push notifications.
  - Each automation step can be independently enabled or disabled. For example, `configuration.push.automation.requestAuthorizationAtLaunch = false` can be used to prevent the automatic request for push permissions at launch.
  - Resources:
    - Updated [_Standard Push Notifications_](https://braze-inc.github.io/braze-swift-sdk/tutorials/braze/b1-standard-push-notifications) tutorial.
    - [`Braze.Configuration.Push.automation`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/configuration-swift.class/push-swift.class/automation-swift.property) property.
    - [`Braze.Configuration.Push.Automation`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/configuration-swift.class/push-swift.class/automation-swift.class) type (provides details about the behavior of each automation step).
- Adds the [`Braze.Configuration.forwardUniversalLinks`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/configuration-swift.class/forwarduniversallinks) configuration. When enabled, the SDK will redirect universal links from Braze campaigns to the appropriate system methods.
- Adds the [`Braze.Notifications.subscribeToUpdates(_:)`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/notifications-swift.class/subscribetoupdates(_:)) method to subscribe to the push notifications handled by the SDK.
  - This method runs the provided closure with a [`Braze.Notifications.Payload`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/notifications-swift.class/payload) class representing the processed push notification.
- Adds the [`Braze.Notifications.deviceToken`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/notifications-swift.class/devicetoken) property to access the most recent notification device token received by the SDK.

## 6.4.0

##### Fixed
- Fixes an issue preventing text fields from being selected in HTML IAMs for iOS 15.
- Fixes an issue where the device model was inaccurately reported as iPad on macOS (_Mac Catalyst_ and _Designed for iPad_ configurations).
- Fixes an issue where custom event and purchase properties would not accept an entry if its value was an empty string.
- Fixes a crash that occurred in the default UI for Content Cards when encountering a zero-value aspect ratio.
- Fixes an issue introduced in 6.0.0 where images in in-app messages would appear smaller than expected when using the compatibility UI (`BrazeUICompat`).

##### Added
- Adds the `unviewedCards` convenience property to the `Braze.ContentCards` class to get the unviewed content cards for the current user.

## 6.3.1

##### Fixed
- Fixes an issue where the previous user's data would not be flushed after calling `changeUser(userId:sdkAuthSignature:)` when the SDK authentication feature is enabled.
- A content card impression can now be logged once per session. Previously, the Braze-provided Content Cards UI would limit to a single impression per card at maximum, irrespective of sessions.
- Fixes an issue that previously caused push notification URLs with percent-encoded characters to fail during decoding.
- Fixes a behavior to automatically set a user's push subscription state to [`optedIn`][opted-in] after push permissions have explicitly been authorized via the Settings app.
- Correctly hides shadows on in-app messages that are configured with a transparent background.
- Fixes a rare crash occurring when deinitializing the Braze instance.

##### Added
- Adds additional logging for network-related decoding errors.

[opted-in]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/user-swift.class/subscriptionstate/optedin

## 6.3.0

##### Fixed
- "Confirm" and "Cancel" notification categories now show the correct titles on the action buttons.

##### Added
- Adds a new `SDKMetadata` option `.reactnativenewarch` for the React Native New Architecture.
- Adds public initializers for [`Braze.URLContext`][url-context] and [`Braze.ModalContext`][modal-context].

[url-context]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/urlcontext/
[modal-context]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/modalcontext/

## 6.2.0

##### Fixed
- Fixes a crash introduced in 6.0.0 when displaying an HTML in-app message using the `BrazeUICompat` module.
- Removed a system call that is known to be slow on older versions of macOS. This resolves the SDK hanging during initialization on Mac Catalyst when running on affected macOS versions.

##### Added
- Adds support for `target` attributes on anchor tags in HTML in-app messages (e.g. `<a href="..." target="_blank"></a>`).
  - Adding the `target` attribute to links will allow them to open in a new webview without dismissing the current in-app message.
  - This behavior can be disabled via the `linkTargetSupport` property of the `BrazeInAppMessageUI.HtmlView.Attributes` struct.
  - See our [Custom HTML in-app messages](https://www.braze.com/docs/user_guide/message_building_by_channel/in-app_messages/traditional/customize/html_in-app_messages/) documentation page for more details.

## 6.1.0

##### Fixed
- Fixes an issue that led to disproportionately large close buttons on in-app messages when the user has set a large font size in the device settings.
- Fixes an issue that would lock the screen in a specific orientation after the dismissal of an in-app message customized to be presented in that orientation.
  - This issue only impacted iOS 16.0+ devices.

##### Added
- Adds new versions of `setCustomAttribute` to the User object to support [nested custom attributes][nca-docs].
  - Renames `User.setCustomAttributeArray(key: String, array: [String]?)` to `setCustomAttribute(…)` to align it with other custom attribute setters, and adds "string" to the `addTo` and `removeFrom` attribute array methods to clarify which custom attributes they're used for.

[nca-docs]: https://www.braze.com/docs/user_guide/data_and_analytics/custom_data/custom_attributes/nested_custom_attribute_support

## 6.0.0

##### Breaking
- The in-app message data models sent to [`BrazeInAppMessagePresenter.present(message:)`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/brazeinappmessagepresenter/present(message:)) now contain remote asset URLs. Previously, these data models would contain local asset URLs.
  - This change is only breaking in two situations:
    - When implementing a custom `BrazeInAppMessagePresenter`.
    - When relying on asset URLs being local in the message provided by [`BrazeInAppMessageUIDelegate.inAppMessage(_:displayChoiceForMessage:)`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazeui/brazeinappmessageuidelegate/inappmessage(_:displaychoiceformessage:)-9w1nb)
  - The in-app message data models available from the other [`BrazeInAppMessageUIDelegate`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazeui/brazeinappmessageuidelegate) methods remain unchanged and contain local asset URLs.

##### Added
- The in-app message context now provides two additional methods:
  - [`getLocalAssets(urls:destinationURL:completionHandler:)`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/inappmessageraw/context-swift.class/getlocalassets(urls:destinationurl:completionhandler:)): Retrieves the local assets associated with the given remote asset URLs.
  - [`withLocalAssets(message:destinationURL:completionHandler:)`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/inappmessageraw/context-swift.class/withlocalassets(message:destinationurl:completionhandler:)): Returns a modified in-app message with all remote asset URLs replaced with local ones.

## 5.14.0

##### Fixed
- VoiceOver now correctly focuses on in-app message views when they are presented.
- Fixes an issue causing in-app messages with re-eligibility disabled to display multiple times under certain conditions.
- Fixes an issue where modal and full in-app message headers were truncated on devices running iOS versions lower than 16 when displaying non-ASCII characters.
- The dynamic variant of `BrazeUI.framework` in the release artifact `braze-swift-sdk-prebuilt.zip` is now an actual dynamic framework. Previously, this specific framework was mistakenly distributed as a static framework.

##### Added
- Adds the `BrazeSDKAuthDelegate` protocol as a separate protocol from `BrazeDelegate`, allowing for more flexible integrations.
  - Apps implementing `BrazeDelegate.braze(_:sdkAuthenticationFailedWithError:)` should migrate to use `BrazeSDKAuthDelegate` and remove the old implementation. The `BrazeDelegate` method will be removed in a future major release.

## 5.13.0

##### Fixed
- Fixes an issue where the SDK would automatically track body clicks on non-legacy HTML in-app messages.

##### Added
- Adds the synchronous `deviceId` property on the Braze instance.
  - `deviceId(queue:completion:)` is now deprecated.
  - `deviceId() async` is now deprecated.
- Adds the `automaticBodyClicks` property to the HTML in-app message view attributes. This property can be used to enable automatic body clicks tracking on non-legacy HTML in-app messages.
  - This property is `false` by default.
  - This property is ignored for legacy HTML in-app messages.

## 5.12.0

> Starting with this release, this SDK will use [Semantic Versioning](https://semver.org/).

##### Added
- Adds `json()` and `decoding(json:)` public methods to the Feature Flag model object for JSON encoding/decoding.

## 5.11.2

##### Fixed
- Fixes a crash occurring when the SDK is configured with a flush interval of `0` and network connectivity is poor.

## 5.11.1

##### Fixed
- Fixes an issue preventing the correct calculation of the delay when retrying failed requests. This led to a more aggressive retry schedule than intended.
- Improves the performance of Live Activity tracking by de-duping push token tag requests.
- Fixes an issue in `logClick(using:)` where it would incorrectly open the `url` field in addition to logging a click for metrics. It now only logs a click for metrics.
  - This applies to the associated APIs for content cards, in-app messages, and news feed cards.
  - It is still recommended to use the associated `Context` object to log interactions instead of these APIs.

##### Added
- Adds [`BrazeKit.overrideResourceBundle`] and [`BrazeUI.overrideResourceBundle`] to allow for custom resource bundles to be used by the SDK.
  - This feature is useful when your setup prevents you from using the default resource bundle (e.g. Tuist).

[`BrazeKit.overrideResourceBundle`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/overrideresourcebundle
[`BrazeUI.overrideResourceBundle`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazeui/overrideresourcebundle/

## 5.11.0

##### Added
- Adds support for [Live Activities](https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities) via the `liveActivities` module on the Braze instance.
  - This feature provides the following new methods for tracking and managing Live Activities with the Braze push server:
    - `launchActivity(pushTokenTag:activity:)`
    - `resumeActivities(ofType:)`
  - This feature requires iOS 16.1 and up.
  - To learn how to integrate this feature, refer to the [setup tutorial](https://braze-inc.github.io/braze-swift-sdk/tutorials/braze/b4-live-activities/).
- Adds logic to re-synchronize Content Cards on SDK version changes.
- Adds provisional support for Xcode 14.3 Beta via the [`braze-inc/braze-swift-sdk-xcode-14-3-preview`](https://github.com/braze-inc/braze-swift-sdk-xcode-14-3-preview) repository.

## 5.10.1

##### Changed
- Dynamic versions of the prebuilt xcframeworks are now available in the `braze-swift-sdk-prebuilt.zip` release artifact.

## 5.10.0

##### Fixed
- Fixes an issue where test content cards were removed before their expiration date.
- Fixes an issue in `BrazeUICompat` where the status bar appearance wasn't restored to its original state after dismissing a full in-app message.
- Fixes an issue when decoding notification payloads where some valid boolean values weren't correctly parsed.

##### Changed
- In-app modal and full-screen messages are now rendered with `UITextView`, which better supports large amounts of text and extended UTF code points.

## 5.9.1

##### Fixed
- Fixes an issue preventing local expired content cards from being removed.
- Fixes a behavior that could lead to background tasks extending beyond the expected time limit with inconsistent network connectivity.

##### Added
- Adds `logImpression(using:)` and `logClick(buttonId:using:)` to news feed cards.

## 5.9.0

##### Breaking
- Raises the minimum deployment target to iOS 11.0 and tvOS 11.0.
- Raises the Xcode version to 14.1 (14B47b).

##### Fixed
- Fixes an issue where the post-click webview would close automatically in some cases.
- Fixes a behavior where the current user messaging data would not be directly available after initializing the SDK or calling `changeUser(userId:)`.
- Fixes an issue preventing News Feed data models from being available offline.
- Fixes an issue where the release binaries could emit warnings when generating dSYMs.

##### Changed
- SwiftPM and CocoaPods now use the same release assets.

##### Added
- Adds support for the upcoming Braze Feature Flags product.
- Adds the `braze-swift-sdk-prebuilt.zip` archive to the release assets.
  - This archive contains the prebuilt xcframeworks and their associated resource bundles.
  - The content of this archive can be used to manually integrate the SDK.
- Adds the `Examples-Manual.xcodeproj` showcasing how to integrate the SDK using the prebuilt release assets.
- Adds support for Mac Catalyst for example applications, available at [Support/Examples/](./Support/Examples/README.md)
- Adds support to convert from `Data` into an in-app message, content card, or news feed card via `decoding(json:)`.

## 5.8.1

##### Fixed
- Fixes a conflict with the shared instance of [`ProcessInfo`], allowing low power mode notifications to trigger correctly.

##### Changed
- Renames the `BrazeLocation` class to `BrazeLocationProvider` to avoid shadowing the module of the same name ([SR-14195](https://bugs.swift.org/browse/SR-14195)).

[`ProcessInfo`]: https://developer.apple.com/documentation/foundation/processinfo

## 5.8.0

To help migrate your app from the Appboy-iOS-SDK to our Swift SDK, this release includes the `Appboy-iOS-SDK` [migration guide]:
- Follow step-by-step instructions to migrate each feature to the new APIs.
- Includes instructions for a minimal migration scenario via our compatibility libraries.

##### Added
- Adds compatibility libraries `BrazeKitCompat` and `BrazeUICompat`:
  - Provides all the old APIs from `Appboy-iOS-SDK` to easily start migrating to the Swift SDK.
  - See the [migration guide] for more details.
- Adds support for [News Feed](https://www.braze.com/docs/user_guide/engagement_tools/news_feed) data models and analytics.
  - News Feed UI is not supported by the Swift SDK. See the [migration guide] for instructions on using the compatibility UI.

[migration guide]: https://braze-inc.github.io/braze-swift-sdk/documentation/braze/appboy-migration-guide

## 5.7.0

##### Fixed
- Fixes an issue where modal image in-app messages would not respect the aspect ratio of the image when the height of the image is larger than its width.

##### Changed
- Changes modal, modal image, full, and full image in-app message view attributes to use the `ViewDimension` type for their `minWidth`, `maxWidth` and `maxHeight` attributes.
  - The `ViewDimension` type enables providing different values for regular and large size-classes.

##### Added
- Adds a configuration to use a randomly generated UUID instead of IDFV as the device ID: [`useUUIDAsDeviceId`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/configuration-swift.class/useuuidasdeviceid).
  - This configuration defaults to `false`. To opt in to this feature, set this value to `true`.
  - Enabling this value will only affect new devices. Existing devices will use the device identifier that was previously registered.

## 5.6.4

##### Fixed
- Fixes an issue preventing the execution of `BrazeDelegate` methods when setting the delegate using Objective-C.
- Fixes an issue where triggering an in-app message twice with the same event did not place the message on the in-app message stack under certain conditions.

##### Added
- Adds the public `id` field to `Braze.InAppMessage.Data`.
- Adds `logImpression(using:)` and `logClick(buttonId:using:)` to both in-app messages and content cards, and adds `logDismissed(using:)` to content cards.
  - It is recommended to continue using the associated `Context` to log impressions, clicks, and dismissals for the majority of use cases.
- Adds Swift concurrency to support async/await versions of the following public methods. These methods can be used as alternatives to their corresponding counterparts that use completion handlers:
  - [`Braze.User.id()`]
  - [`Braze.deviceId()`]
  - [`ContentCards.requestRefresh()`]
  - [`ContentCards.cardsStream`] as an alternative to [`ContentCards.subscribeToUpdates(_:)`]

[Appboy-iOS-SDK: Migration guide]: https://braze-inc.github.io/braze-swift-sdk/documentation/braze/appboy-migration-guide
[`Braze.User.id()`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/user-swift.class/id()
[`Braze.deviceId()`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/deviceid()
[`ContentCards.requestRefresh()`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/contentcards-swift.class/requestrefresh()
[`ContentCards.cardsStream`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/contentcards-swift.class/cardsstream
[`ContentCards.subscribeToUpdates(_:)`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/contentcards-swift.class/subscribetoupdates(_:)

## 5.6.3

##### Fixed
- Fixes the `InAppMessageRaw` to `InAppMessage` conversion to properly take into account the `extras` dictionary and the `duration`.
- Fixes an issue preventing the execution of the [`braze(_:sdkAuthenticationFailedWithError:)`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/brazedelegate/braze(_:sdkauthenticationfailedwitherror:)-505pz) delegate method in case of an authentication error.

##### Changed
- Improves error logging descriptions for HTTP requests and responses.

## 5.6.2

##### Changed
- Corrected the version number from the previous release.

## 5.6.1

##### Added
- Adds the public initializers `Braze.ContentCard.Context(card:using:)` and `Braze.InAppMessage.Context(message:using:)`.

## 5.6.0

##### Fixed
- The modal webview controller presented after a click now correctly handles non-HTTP(S) URLs (e.g. App Store URLs).
- Fixes an issue preventing some test HTML in-app messages from displaying images.

##### Added
- Learn how to easily customize `BrazeUI` in-app message and content cards UI components with the following documentation and example code:
  - [In-App Message UI Customization] article
  - [Content Cards UI Customization] article
  - `InAppMessageUI-Customization` example scheme
  - `ContentCardUI-Customization` example scheme
- Adds new attributes to `BrazeUI` in-app message UI components:
  - `cornerCurve` to change the [`cornerCurve`]
  - `buttonsAttributes` to change the font, spacing and corner radius of the buttons
  - `imageCornerRadius` to change the image corner radius for slideups
  - `imageCornerCurve` to change the image [`cornerCurve`] for slideups
  - `dismissible` to change whether slideups can be interactively dismissed
- Adds direct accessors to the in-app message view subclass on the [`BrazeInAppMessageUI.messageView`] property.
  - [`slideup`], [`modal`], [`modalImage`], [`full`], [`fullImage`], [`html`], [`control`].
- Adds direct accessors to the content card `title`, `description` and `domain` when available.
- Adds `Braze.Notifications.isInternalNotification` to check if a push notification was sent by Braze for an internal feature.
- Adds [`brazeBridge.changeUser()`] to the HTML in-app messages JavaScript bridge.

[In-App Message UI Customization]: https://braze-inc.github.io/braze-swift-sdk/documentation/braze/in-app-message-customization
[Content Cards UI Customization]: https://braze-inc.github.io/braze-swift-sdk/documentation/braze/content-cards-customization
[`cornerCurve`]: https://developer.apple.com/documentation/quartzcore/calayer/3152596-cornercurve
[`BrazeInAppMessageUI.messageView`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazeui/brazeinappmessageui/messageview
[`brazeBridge.changeUser()`]: https://www.braze.com/docs/user_guide/message_building_by_channel/in-app_messages/customize/html_in-app_messages/#bridge
[`slideup`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazeui/inappmessageview/slideup
[`modal`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazeui/inappmessageview/modal
[`modalImage`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazeui/inappmessageview/modalimage
[`full`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazeui/inappmessageview/full
[`fullImage`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazeui/inappmessageview/fullimage
[`html`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazeui/inappmessageview/html
[`control`]: https://braze-inc.github.io/braze-swift-sdk/documentation/brazeui/inappmessageview/control

##### Changed

- The `applyAttributes()` method for `BrazeContentCardUI` views now take the `attributes` explicitly as a parameter.

## 5.5.1

##### Fixed
- Fixes an issue where content cards would not be properly removed when stopping a content card campaign on the dashboard and selecting the option _Remove card after the next sync (e.g. session start)_.

## 5.5.0

##### Added
- Adds support for host apps written in Objective-C.
  - Braze Objective-C types start either with `BRZ` or `Braze`, e.g.:
    - `Braze`
    - `BrazeDelegate`
    - `BRZContentCardRaw`
  - See our Objective-C [Examples](Examples/) project.
- Adds [`BrazeDelegate.braze(_:noMatchingTriggerForEvent:)`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/brazedelegate/braze(_:nomatchingtriggerforevent:)-8rt7y) which is called if no Braze in-app message is triggered for a given event.

##### Changed
- In `Braze.Configuration.Api`:
  - Renamed `SdkMetadata` to `SDKMetadata`.
  - Renamed `addSdkMetadata(_:)` to `addSDKMetadata(_:)`.
- In `Braze.InAppMessage`:
  - Renamed `Themes.default` to `Themes.defaults`.
  - Renamed `ClickAction.uri` to `ClickAction.url`.
  - Renamed `ClickAction.uri(_:useWebView:)` to `ClickAction.url(_:useWebView:)`.

## 5.4.0

##### Fixed
- Fixes an issue where `brazeBridge.logClick(button_id)` would incorrectly accept invalid `button_id` values like `""`, `[]`, or `{}`.

##### Added
- Adds support for Braze Action Deeplink Click Actions.

## 5.3.2

##### Fixed
- Fixes an issue preventing compilation when importing `BrazeUI` via SwiftPM in specific cases.
- Lowers `BrazeUI` minimum deployment target to iOS 10.0.

## 5.3.1

##### Fixed
- Fixes an HTML in-app message issue where clicking a link in an iFrame would launch a separate webview and close the message, instead of redirecting within the iFrame.
- Fixes the rounding of In-App Message modal view top corners.
- Fixes the display of modals and full screen in-app messages on iPads in landscape mode.

##### Added
- Adds two Example schemes:
  - InAppMessage-Custom-UI:
    - Demonstrates how to implement your own custom In-App Message UI.
    - Available on iOS and tvOS.
  - ContentCards-Custom-UI:
    - Demonstrates how to implement your own custom Content Card UI.
    - Available on iOS and tvOS.
- Adds [`Braze.InAppMessage.ClickAction.uri`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/inappmessage/clickaction/uri) for direct access.
- Adds [`Braze.ContentCard.ClickAction.uri`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/contentcard/clickaction/uri/) for direct access.
- Adds [`Braze.deviceId(queue:completion:)`](https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/deviceid(queue:completion:)) to retrieve the device identifier used by Braze.

## 5.3.0

##### Added
- Adds support for tvOS.
  - See the schemes _Analytics-tvOS_ and _Location-tvOS_ in the [Examples](Examples/) project.

## 5.2.0

##### Added
- Adds [Content Cards](https://www.braze.com/docs/user_guide/message_building_by_channel/content_cards) support.
  - See the [_Content Cards UI_](https://braze-inc.github.io/braze-swift-sdk/tutorials/braze/c2-contentcardsui) tutorial to get started.

##### Changed
- Raises `BrazeUI` minimum deployment target to iOS 11.0 to allow providing SwiftUI compatible Views.

## 5.1.0

##### Fixed
- Fixes an issue where the SDK would be unable to present a webview when the application was already presenting a modal view controller.
- Fixes an issue preventing a full device data update after changing the identified user.
- Fixes an issue preventing events and user attributes from being flushed automatically under certain conditions.
- Fixes an issue delaying updates to push notifications settings.

##### Added
- Adds CocoaPods support.
  - Pods:
    - [BrazeKit](https://cocoapods.org/pods/BrazeKit)
    - [BrazeUI](https://cocoapods.org/pods/BrazeUI)
    - [BrazeLocation](https://cocoapods.org/pods/BrazeLocation)
    - [BrazeNotificationService](https://cocoapods.org/pods/BrazeNotificationService)
    - [BrazePushStory](https://cocoapods.org/pods/BrazePushStory)
  - See [Examples/Podfile](Examples/Podfile) for example integration.
- Adds `Braze.UIUtils.activeTopmostViewController` to get the topmost view controller that is currently being presented by the application.

## 5.0.1

##### Fixed
- Fixes a race condition when retrieving the user's notification settings.
- Fixes an issue where duplicate data could be recorded after force quitting the application.

## 5.0.0 (Early Access)

We are excited to announce the initial release of the Braze Swift SDK!

The Braze Swift SDK is set to replace the [current Braze iOS SDK](https://github.com/Appboy/appboy-ios-sdk/) and provides a more modern API, simpler integration, and better performance.

### Current limitations

The following features are not supported yet:
- ~~Objective-C integration~~
  - Added in [5.5.0](#550)
- ~~tvOS integration~~
  - Added in [5.3.0](#530)
- ~~News Feed~~
  - Added in [5.7.0](#570)
- ~~Content Cards~~
  - Added in [5.2.0](#520)
