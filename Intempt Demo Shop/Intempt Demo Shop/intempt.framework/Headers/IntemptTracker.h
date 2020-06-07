

#ifndef IntemptTracker_h
#define IntemptTracker_h
@import UIKit;

@interface Intempt : NSObject
+ (void)TrackingWithOrgId:(NSString*)orgId andSourceId:(NSString*)trackerId andToken:(NSString*)token;
+ (void) enableGeoLocationAlways;
+ (void) enableGeoLocationInUse;
+ (void)identify:(NSString*)identity withProperties:(NSDictionary*)userProperties error:(NSError**)error;
+ (BOOL)addEvent:(NSDictionary*)event toEventCollection:(NSString*)eventCollection error:(NSError**)error;
+ (void)track:(NSString*)collectionName withProperties:(NSMutableArray*)userProperties error:(NSError**)error;
+ (void)beaconUUIDString:(NSString*)uuid;
@end

#endif
