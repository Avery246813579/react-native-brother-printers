// ReactNativeBrotherPrinters.h

#import <React/RCTBridgeModule.h>
#import <BRLMPrinterKit/BRPtouchNetworkManager.h>

@interface ReactNativeBrotherPrinters : NSObject <RCTBridgeModule, BRPtouchNetworkDelegate> {
    NSMutableArray *_brotherDeviceList;
    BRPtouchNetworkManager    *_networkManager;
}

@end
