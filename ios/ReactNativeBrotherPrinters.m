// ReactNativeBrotherPrinters.m

#import "ReactNativeBrotherPrinters.h"
#import <React/RCTConvert.h>

@implementation ReactNativeBrotherPrinters

NSString *const DISCOVER_ERROR = @"DISCOVER_ERROR";

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

-(void)startObserving {
    hasListeners = YES;
}

-(void)stopObserving {
    hasListeners = NO;
}

- (NSArray<NSString *> *)supportedEvents {
    return @[
        @"onBrotherLog",

        @"onDiscoverPrinters",
    ];
}

RCT_REMAP_METHOD(discoverPrinters, discoverOptions:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSLog(@"Called the function");

    _brotherDeviceList = [[NSMutableArray alloc] initWithCapacity:0];

    _networkManager = [[BRPtouchNetworkManager alloc] init];
    _networkManager.delegate = self;

    NSString *path = [[NSBundle mainBundle] pathForResource:@"PrinterList" ofType:@"plist"];

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

RCT_REMAP_METHOD(printImage, deviceInfo:(NSDictionary *)device printImageOptions:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSLog(@"Called the printImage function");
    BRPtouchDeviceInfo *deviceInfo = [self deserializeDeviceInfo:device];

    BRLMChannel *channel = [[BRLMChannel alloc] initWithWifiIPAddress:deviceInfo.strIPAddress];

    BRLMPrinterDriverGenerateResult *driverGenerateResult = [BRLMPrinterDriverGenerator openChannel:channel];
    if (driverGenerateResult.error.code != BRLMOpenChannelErrorCodeNoError ||
        driverGenerateResult.driver == nil) {
        NSLog(@"%@", @(driverGenerateResult.error.code));
        return;
    }

    _imageStr = [RCTConvert NSString:options[@"uri"]];

    NSLog(@"We opened the path");

    NSString * paperSize = [self defaultPaperSize:deviceInfo.strModelName];
    NSLog(@"Paper Size: %@", paperSize);

    BRLMPrinterDriver *printerDriver = driverGenerateResult.driver;

    BRLMPrinterModel model = [BRLMPrinterClassifier transferEnumFromString:deviceInfo.strModelName];
    BRLMQLPrintSettings *qlSettings = [[BRLMQLPrintSettings alloc] initDefaultPrintSettingsWithPrinterModel:model];

    qlSettings.autoCut = true;

    NSURL *url = [NSURL URLWithString:_imageStr];
    BRLMPrintError *printError = [printerDriver printImageWithURL:url settings:qlSettings];

    if (printError.code != BRLMPrintErrorCodeNoError) {
        NSLog(@"Error - Print Image: %@", printError);
    } else {
        NSLog(@"Success - Print Image");
    }

    [printerDriver closeChannel];
}

-(void)didFinishSearch:(id)sender
{
    NSLog(@"didFinishedSearch");

    //  get BRPtouchNetworkInfo Class list
    [_brotherDeviceList removeAllObjects];
    _brotherDeviceList = (NSMutableArray*)[_networkManager getPrinterNetInfo];

    NSLog(@"_brotherDeviceList [%@]",_brotherDeviceList);

    NSMutableArray *_serializedArray = [[NSMutableArray alloc] initWithCapacity:_brotherDeviceList.count];

    for (BRPtouchDeviceInfo *deviceInfo in _brotherDeviceList) {
        [_serializedArray addObject:[self serializeDeviceInfo:deviceInfo]];

        NSLog(@"Model: %@, IP Address: %@", deviceInfo.strModelName, deviceInfo.strIPAddress);

    }

    [self sendEventWithName:@"onDiscoverPrinters" body:_serializedArray];

    return;
}

- (NSString *)defaultPaperSize: (NSString *) printer
{
    NSString *result = nil;

    NSString *pathInPrintSettings   = [[NSBundle mainBundle] pathForResource:@"PrinterList" ofType:@"plist"];
    if (pathInPrintSettings) {
        NSDictionary *priterListArray = [NSDictionary dictionaryWithContentsOfFile:pathInPrintSettings];
        if (priterListArray) {
            result = [[[priterListArray objectForKey:printer] objectForKey:@"PaperSize"] objectAtIndex:0];
        }
    }
    return result;
}

- (NSDictionary *) serializeDeviceInfo:(BRPtouchDeviceInfo *)device {
    return @{
        @"ipAddress": device.strIPAddress,
        @"location": device.strLocation,
        @"modelName": device.strModelName,
        @"printerName": device.strPrinterName,
        @"serialNumber": device.strSerialNumber,
        @"nodeName": device.strNodeName,
        @"macAddress": device.strMACAddress,
    };
}

- (BRPtouchDeviceInfo *) deserializeDeviceInfo:(NSDictionary *)device {
    BRPtouchDeviceInfo *deviceInfo = [[BRPtouchDeviceInfo alloc] init];

//    return @{
//        @"ipAddress": device.strIPAddress,
//        @"location": device.strLocation,
//        @"modelName": device.strModelName,
//        @"printerName": device.strPrinterName,
//        @"serialNumber": device.strSerialNumber,
//        @"nodeName": device.strNodeName,
//        @"macAddress": device.strMACAddress,
//    };
//
//
    deviceInfo.strIPAddress = [RCTConvert NSString:device[@"ipAddress"]];
    deviceInfo.strLocation = [RCTConvert NSString:device[@"location"]];
    deviceInfo.strModelName = [RCTConvert NSString:device[@"modelName"]];
    deviceInfo.strPrinterName = [RCTConvert NSString:device[@"printerName"]];
    deviceInfo.strSerialNumber = [RCTConvert NSString:device[@"serialNumber"]];
    deviceInfo.strNodeName = [RCTConvert NSString:device[@"nodeName"]];
    deviceInfo.strMACAddress = [RCTConvert NSString:device[@"macAddress"]];

    NSLog(@"We got here");

    return deviceInfo;
}

@end
