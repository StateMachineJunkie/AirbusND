#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

typedef enum {
    kUDPServerCouldNotBindToIPv4Address = 1,
    kUDPServerCouldNotBindToIPv6Address = 2,
    kUDPServerNoSocketsAvailable = 3,
} UDPServerErrorCode;

typedef struct sockaddr_in SocketAddress;
typedef struct sockaddr_in const* SocketAddressRef;

@interface UDPServer : NSObject
{
@private
    id              __unsafe_unretained delegate;
    NSString*       domain;
    NSString*       name;
    NSString*       type;
    uint16_t        port;
    CFSocketRef     ipv4socket;
    NSNetService*   netService;
}

@property(nonatomic, assign) id delegate;
@property(nonatomic, copy) NSString* domain;
@property(nonatomic, copy) NSString* name;
@property(nonatomic, copy) NSString* type;
@property(nonatomic) uint16_t port;

- (BOOL)start:(NSError**)error;
- (BOOL)stop;
- (void)sendData:(NSData*)data ToAddress:(SocketAddressRef)socketAddress;

@end

@interface UDPServer (UDPServerDelegateMethods)

- (void)UDPServer:(UDPServer*)server
   didReceiveData:(NSData*)data
      fromAddress:(SocketAddressRef)socketAddress;

@end

