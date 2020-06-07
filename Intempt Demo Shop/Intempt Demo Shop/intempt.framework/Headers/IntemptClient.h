@import Foundation;
@import CoreLocation;
@protocol intemptDelegate <NSObject>
-(void)didEnterRegion:(NSString*)entryTime;
-(void)didExitRegion:(NSString*)exitTime;
@end
@interface IntemptClient : NSObject <CLLocationManagerDelegate>
{
    NSString * visitorId,*CfbundleIdentifier,*parentId, *eventId;
    double latitude;
    double longitude;
    NSMutableDictionary *profileDic ,*sceneDic,* interactionDic,*deviceDic,*geoDic,*appDic,*launchDic,*screenDic ;
    NSMutableArray *profileArydata,*launchArydata,*sceneArydata,*interactionArydata,*interactionArydatas,*ary;
    NSMutableDictionary *dictValue,*dictvalue1;
    NSMutableArray * beaconData;
    NSString *region,*country,*city,*strCheck,*str;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    int count;
}
@property (nonatomic,weak) id<intemptDelegate> delegate;


@property (nonatomic, strong) NSDictionary *propertiesOverridesDictionary;


@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, strong) NSString *baseUrl;

+ (IntemptClient *)sharedClientWithOrganizationId:(NSString *)organizationId andTrackerId:(NSString *)trackerId andToken:(NSString *)token;


 
+ (IntemptClient *)sharedClient;

/**
 Call this to authorize geo location always (iOS 8 and above). You must also add NSLocationAlwaysUsageDescription string to Info.plist to
 authorize geo location always (foreground and background), call this BEFORE doing anything else with ITClient.
 
 */
+ (void)authorizeGeoLocationAlways;

/**
 Call this to authorize geo location when in use (iOS 8 and above). You must also add NSLocationWhenInUsageDescription string to Info.plist to
 authorize geo location when in use (foreground), call this BEFORE doing anything else with ITClient.
 
 When In Use is AUTHORIZED by default.
 */
+ (void)authorizeGeoLocationWhenInUse;

/**
 Call this to disable geo location. If you don't want to pop up a message to users asking them to approve geo location
 services, call this BEFORE doing anything else with ITClient.
 
 Geo location is ENABLED by default.
 */
+ (void)disableGeoLocation;

/**
 Call this to enable geo location. You'll probably only have to call this if for some reason you've explicitly
 disabled geo location.
 
 Geo location is ENABLED by default.
 */
+ (void)enableGeoLocation;

/**
 Call this to disable debug logging. It's disabled by default.
 */
+ (void)disableLogging;

/**
 Call this to enable debug logging.
 */
+ (void)enableLogging;

/**
 Returns whether or not logging is currently enabled.
 
 @return true if logging is enabled, false if disabled.
 */
+ (Boolean)isLoggingEnabled;




/**
 Call this to retrieve an instance of ITEventStore.
 
 @return An instance of ITEventStore.
 */


/**
 Call this if your code needs to use more than one Intempt project.  By convention, if you
 call this, you're responsible for releasing the returned instance once you're finished with it.
 
 Otherwise, just use [ITClient sharedClient].
 
 @param organizationId Your Intempt Organization ID.
 @param trackerId Your Intempt Tracker ID.
 @param token Your Intempt Tracker security token.
 @return An initialized instance of ITClient.
 */
- (id)initWithOrganizationId:(NSString *)organizationId andTrackerId:(NSString *)trackerId andToken:(NSString *)token;

-(id)initWithOrganizationId:(NSString *)organizationId andTrackerId:(NSString *)sourceId andToken:(NSString *)token andPropertiesOverrides:(NSDictionary *)propertiesOverrides andPropertiesOverridesBlock:(NSDictionary *(^)(NSString *))propertiesOverridesBlock;

- (BOOL)addEvent:(NSDictionary *)event toEventCollection:(NSString *)eventCollection error:(NSError **)anError;

- (void)identify:(NSString*) identity withProperties: (NSDictionary *) userProperties error:(NSError **) error;

- (void)refreshCurrentLocation;
- (void)track:(NSString*) collectionName withProperties: (NSMutableArray *) userProperties error:(NSError **) error;
- (void)uuidString:(NSString*)uuid;


/**
 Returns the Intempt SDK Version
 
 @return The current SDK version string.
 */
+ (NSString *)sdkVersion;


// defines the TBLog macro
#define INTEMPT_LOGGING_ENABLED [IIntemptClient loggingEnabled]
#define TBLog(message, ...)if([IntemptClient isLoggingEnabled]) NSLog(message, ##__VA_ARGS__)

@end

