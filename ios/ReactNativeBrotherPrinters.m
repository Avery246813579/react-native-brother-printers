// ReactNativeBrotherPrinters.m

#import "ReactNativeBrotherPrinters.h"

@implementation ReactNativeBrotherPrinters

NSString *const DISCOVER_ERROR = @"DISCOVER_ERROR";

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

RCT_REMAP_METHOD(discoverPrinters, discoverOptions:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSLog(@"Called the function");

    _brotherDeviceList = [[NSMutableArray alloc] initWithCapacity:0];

    _networkManager = [[BRPtouchNetworkManager alloc] init];
    _networkManager.delegate = self;

    NSString *    path = [[NSBundle mainBundle] pathForResource:@"PrinterList" ofType:@"plist"];
    if (path) {
        NSDictionary *printerDict = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray *printerList = [[NSArray alloc] initWithArray:printerDict.allKeys];
        
        [_networkManager setPrinterNames:printerList];
    } else {
        NSLog(@"Could not find PrinterList.plist");
    }

    //    Start printer search
    int response = [_networkManager startSearch: 5.0];
    
    if (response == RET_TRUE) {
        resolve(Nil);
    } else {
        reject(DISCOVER_ERROR, @"A problem occured when trying to execute discoverPrinters", Nil);
    }
}

-(void)didFinishSearch:(id)sender
{
    NSLog(@"didFinishedSearch");

    //  get BRPtouchNetworkInfo Class list
    [_brotherDeviceList removeAllObjects];
    _brotherDeviceList = (NSMutableArray*)[_networkManager getPrinterNetInfo];

    NSLog(@"_brotherDeviceList [%@]",_brotherDeviceList);

    return;
}


@end
