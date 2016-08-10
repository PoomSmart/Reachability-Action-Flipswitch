#import <Flipswitch/FSSwitchDataSource.h>
#import <Flipswitch/FSSwitchPanel.h>
#import "Settings.h"
#import "Header.h"

@interface ReachabilityActionSwitch : NSObject
@end

@implementation ReachabilityActionSwitch

typedef void(^setState)(BOOL);

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier
{
	SBReachabilityManager *manager = [NSClassFromString(@"SBReachabilityManager") sharedInstance];
	BOOL active = [manager reachabilityModeActive];
	return active ? FSSwitchStateOn : FSSwitchStateOff;
}

- (BOOL)needCleanup
{
	SBAlertItemsController *alert = (SBAlertItemsController *)[NSClassFromString(@"SBAlertItemsController") sharedInstance];
	SBNotificationCenterController *nc = (SBNotificationCenterController *)[NSClassFromString(@"SBNotificationCenterController") sharedInstance];
	SBControlCenterController *cc = (SBControlCenterController *)[NSClassFromString(@"SBControlCenterController") sharedInstance];
	SBAssistantController *siri = (SBAssistantController *)[NSClassFromString(@"SBAssistantController") sharedInstance];
	return [alert hasVisibleAlert] || [nc isVisible] || [siri isPluginRunning] || [cc isVisible];
}

- (void)cleanupIfNeededWithCompletion:(setState)block active:(BOOL)active
{
	if (!active) {
		SBAlertItemsController *alert = (SBAlertItemsController *)[NSClassFromString(@"SBAlertItemsController") sharedInstance]; 
		if ([alert hasVisibleAlert]) [alert deactivateAlertItem:[alert visibleAlertItem]];
		SBNotificationCenterController *nc = (SBNotificationCenterController *)[NSClassFromString(@"SBNotificationCenterController") sharedInstance];
		if ([nc isVisible]) [nc dismissAnimated:YES];
		SBAssistantController *siri = (SBAssistantController *)[NSClassFromString(@"SBAssistantController") sharedInstance];
		if ([siri isPluginRunning]) [siri dismissPluginForEvent:0];
		SBControlCenterController *cc = (SBControlCenterController *)[NSClassFromString(@"SBControlCenterController") sharedInstance];
		if ([cc isVisible]) [cc dismissAnimated:YES];
	}
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC);
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		block(YES);
	});
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier
{
	if (newState == FSSwitchStateIndeterminate)
		return;
	SBReachabilityManager *manager = [NSClassFromString(@"SBReachabilityManager") sharedInstance];
	BOOL active = [manager reachabilityModeActive];
	BOOL cleanup = CFPreferencesGetAppBooleanValue(cleanupKey, prefKey, NULL);
	if ([self needCleanup] && cleanup) {
		[self cleanupIfNeededWithCompletion:^(BOOL finished) {
			if (finished)
				active ? [manager _handleReachabilityDeactivated] : [manager _handleReachabilityActivated];
		} active:active];
	} else
		active ? [manager _handleReachabilityDeactivated] : [manager _handleReachabilityActivated];
}

- (Class <FSSwitchSettingsViewController>)settingsViewControllerClassForSwitchIdentifier:(NSString *)switchIdentifier
{
	return [ReachabilityActionSwitchSettingsViewController class];
}

@end