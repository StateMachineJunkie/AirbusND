#import "UDPServer.h"
//#include <sys/socket.h>
//#include <netinet/in.h>
//#include <unistd.h>

NSString* const UDPServerErrorDomain = @"UDPServerErrorDomain";

@implementation UDPServer

#pragma mark -
#pragma mark Initialization

- (NSString*)description
{
    return @"Airbus Navigation Display UDP Server";
}

- (void)dealloc
{
    [self stop];
}

- (void)awakeFromNib
{
    MCLog(@"%@: awakeFromNib", self);
}

#pragma mark -
#pragma mark Properties

@synthesize delegate;
@synthesize domain;
@synthesize name;
@synthesize type;
@synthesize port;

#pragma mark -
#pragma mark Methods

- (void)handleNewData:(NSData*)data fromAddress:(NSData*)addr
{
    // if the delegate implements the delegate method, call it  
    if ( delegate &&
        [delegate respondsToSelector:@selector(UDPServer:didReceiveData:fromAddress:)] )
    {
        SocketAddressRef socketAddress = [addr bytes];
        [delegate UDPServer:self
             didReceiveData:data
                fromAddress:socketAddress];
    }
}

// This function is called by CFSocket when a new packet comes in.
// We gather some data here, and convert the function call to a method
// invocation on UDPServer.
static void
UDPServerRecvCallBack(CFSocketRef             udpSocket,
                      CFSocketCallBackType    type,
                      CFDataRef               address,
                      void const*             data,
                      void*                   info)
{
    UDPServer* server = (__bridge UDPServer *)info;
    
    if ( kCFSocketDataCallBack == type )
    { 
        [server handleNewData:(__bridge NSData*)data fromAddress:(__bridge NSData*)address];
    }
}

- (void)sendData:(NSData*)data ToAddress:(SocketAddressRef)socketAddress
{
    NSData* address = [NSData dataWithBytes:socketAddress length:sizeof(SocketAddress)];
    CFSocketError result = CFSocketSendData(ipv4socket, (CFDataRef)address, (CFDataRef)data, 0);
    NSAssert1(0 == result, @"CFSocketSendData failed: errno = %d", errno);
}

- (BOOL)start:(NSError**)error
{
    CFSocketContext socketCtxt = { 0, (__bridge void *)(self), NULL, NULL, NULL };
    
    ipv4socket = CFSocketCreate(kCFAllocatorDefault,
                                AF_INET, SOCK_DGRAM,
                                IPPROTO_UDP,
                                kCFSocketDataCallBack,
                                (CFSocketCallBack)&UDPServerRecvCallBack,
                                &socketCtxt);
    
    if ( NULL == ipv4socket )
    {
        if ( error )
        {
            *error = [[NSError alloc] initWithDomain:UDPServerErrorDomain
                                                code:kUDPServerNoSocketsAvailable
                                            userInfo:nil];
        }
        
        if ( ipv4socket )
        {
            CFRelease(ipv4socket);
        }
        
        ipv4socket = NULL;
        return NO;
    }
#if 0
    int yes = 1;

    setsockopt(CFSocketGetNative(ipv4socket),
               SOL_SOCKET,
               SO_REUSEADDR,
               (void*)&yes,
               sizeof(yes));
#endif
    struct sockaddr_in addr4;
    
    addr4.sin_len           = sizeof(struct sockaddr_in);
    addr4.sin_family        = AF_INET;
    addr4.sin_port          = htons(port);
    addr4.sin_addr.s_addr   = htonl(INADDR_ANY);
    memset(&addr4.sin_zero[0], 0, sizeof(addr4.sin_zero));
    
    NSData* address4 = [NSData dataWithBytes:&addr4 length:sizeof(addr4)];

    if ( kCFSocketSuccess != CFSocketSetAddress(ipv4socket, (CFDataRef)address4) )
    {
        if ( error )
        {
            *error = [[NSError alloc] initWithDomain:UDPServerErrorDomain
                                                code:kUDPServerCouldNotBindToIPv4Address
                                            userInfo:nil];
        }
        
        if ( ipv4socket )
        {
            CFRelease(ipv4socket);
        }
        
        ipv4socket =  NULL;
        return NO;
    }
    
    // set up the run loop sources for the sockets
    CFRunLoopRef cfrl = CFRunLoopGetCurrent();
    CFRunLoopSourceRef source4 = CFSocketCreateRunLoopSource(kCFAllocatorDefault, ipv4socket, 0);
    CFRunLoopAddSource(cfrl, source4, kCFRunLoopCommonModes);
    CFRelease(source4);

    // we can only publish the service if we have a type to publish with
    if ( nil != type )
    {
        NSString *publishingDomain = domain ? domain : @"";
        NSString *publishingName = nil;
        
        if ( nil != name )
        {
            publishingName = name;
        }
        else
        {
            NSString * thisHostName = [[NSProcessInfo processInfo] hostName];
            
            if ( [thisHostName hasSuffix:@".local"] )
            {
                publishingName = [thisHostName substringToIndex:([thisHostName length] - 6)];
            }
        }
        
        netService = [[NSNetService alloc] initWithDomain:publishingDomain
                                                     type:type
                                                     name:publishingName
                                                     port:port];
        [netService publish];
    }

    return YES;
}

- (BOOL)stop
{
    [netService stop];
    netService = nil;
    CFSocketInvalidate(ipv4socket);
    CFRelease(ipv4socket);
    ipv4socket = NULL;
    return YES;
}

@end

