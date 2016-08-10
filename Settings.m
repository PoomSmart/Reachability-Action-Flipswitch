#import "Settings.h"
#import "Header.h"

@implementation ReachabilityActionSwitchSettingsViewController

- (id)init
{
	return [super initWithStyle:UITableViewStyleGrouped];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"] ?: [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"] autorelease];
	cell.textLabel.text = @"Cleanup before activation";
	CFPreferencesAppSynchronize(prefKey);
	cell.accessoryType = CFPreferencesGetAppBooleanValue(cleanupKey, prefKey, NULL) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[tableView cellForRowAtIndexPath:indexPath].accessoryType = cellChecked ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
	NSInteger value = cellChecked ? 0 : 1;
	cellChecked = !cellChecked;
	CFPreferencesSetAppValue(cleanupKey, (CFTypeRef)[NSNumber numberWithInteger:value], prefKey);
	CFPreferencesAppSynchronize(prefKey);
}

@end