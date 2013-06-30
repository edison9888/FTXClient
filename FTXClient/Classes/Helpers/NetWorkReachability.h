

#import <Foundation/Foundation.h>
#import <sys/socket.h>

@class NetworkReachability;

@protocol NetworkReachabilityDelegate <NSObject>
- (void) networkReachabilityDidUpdate:(NetworkReachability*)reachability;
@end

@interface NetworkReachability : NSObject
{
@private
	void *_reachability;
	CFRunLoopRef _runLoop;
}

+ (NetworkReachability *)sharedReachability;

- (id) init; //Use default route
- (id) initWithAddress:(const struct sockaddr*)address;
- (id) initWithIPv4Address:(UInt32)address; //The "address" is assumed to be in host-endian
- (id) initWithHostName:(NSString*)name;

@property(nonatomic, assign) id<NetworkReachabilityDelegate> delegate;

@property(nonatomic, readonly, getter=isReachable) BOOL reachable;
@property(nonatomic, readonly) BOOL IsWifi;

- (BOOL) isConnectionRequired ;

@end