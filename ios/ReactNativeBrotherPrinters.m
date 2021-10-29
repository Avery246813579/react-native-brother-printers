// ReactNativeBrotherPrinters.m

#import "ReactNativeBrotherPrinters.h"

@implementation ReactNativeBrotherPrinters

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(sampleMethod:(NSString *)stringArgument numberParameter:(nonnull NSNumber *)numberArgument callback:(RCTResponseSenderBlock)callback)
{
    NSLog(@"Called the function");

    _brotherDeviceList = [[NSMutableArray alloc] initWithCapacity:0];
    
    _networkManager = [[BRPtouchNetworkManager alloc] init];
    _networkManager.delegate = self;
    
    NSString *    path = [[NSBundle mainBundle] pathForResource:@"PrinterList" ofType:@"plist"];
    if( path )
    {
        NSDictionary *printerDict = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray *printerList = [[NSArray alloc] initWithArray:printerDict.allKeys];
        [_networkManager setPrinterNames:printerList];
    }
    
    //    Start printer search
    [_networkManager startSearch: 5.0];

    callback(@[[NSString stringWithFormat: @"numberArgument: %@ stringArgument: %@", numberArgument, stringArgument]]);
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
