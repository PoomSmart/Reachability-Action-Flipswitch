#import <Foundation/Foundation.h>

@interface SBReachabilityTrigger : NSObject
- (void)biometricEventMonitor:(id)monitor handleBiometricEvent:(unsigned)event;
@end

@interface SBReachabilityHoldTrigger : SBReachabilityTrigger
@end

@interface SBReachabilityTapTrigger : SBReachabilityTrigger
@end

@interface SBReachabilityManager : NSObject {
	SBReachabilityTrigger *_trigger;
}
@property(readonly, nonatomic) BOOL reachabilityModeActive;
+ (SBReachabilityManager *)sharedInstance;
+ (BOOL)reachabilitySupported;
- (void)triggerDidTriggerReachability:(id)arg1;
- (void)_handleReachabilityActivated;
- (void)_handleReachabilityDeactivated;
@end

@interface SBAlertItem : NSObject
@end

@interface SBAlertManager : NSObject
- (SBAlertItem *)activeAlert;
@end

@interface SBAlertItemsController : NSObject
+ (SBAlertItemsController *)sharedInstance;
- (BOOL)hasVisibleAlert;
- (SBAlertManager *)alertManager;
- (SBAlertItem *)visibleAlertItem;
- (void)deactivateAlertItem:(SBAlertItem *)item;
@end

@interface SBNotificationCenterController : NSObject
+ (SBNotificationCenterController *)sharedInstance;
- (BOOL)isVisible;
- (void)dismissAnimated:(BOOL)animated;
@end

@interface SBControlCenterController : NSObject
+ (SBControlCenterController *)sharedInstance;
- (BOOL)isVisible;
- (void)dismissAnimated:(BOOL)animated;
@end

@interface SBAssistantController : NSObject
+ (SBAssistantController *)sharedInstance;
- (BOOL)isPluginRunning;
- (void)dismissPluginForEvent:(int)event;
@end

static CFStringRef const prefKey = CFSTR("com.PS.ReachabilityActionFlipswitch.prefs");
static CFStringRef const cleanupKey = CFSTR("cleanupBeforeActivation");