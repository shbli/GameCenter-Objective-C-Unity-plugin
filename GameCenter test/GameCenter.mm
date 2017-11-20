//
//  GameCenter.m
//  GameCenter test
//
//  Created by Ahmad Alshebli on 6/22/16.
//  Copyright © 2016 PeopleCorpGaming. All rights reserved.
//

#import "GameCenter.h"

@implementation GameCenter


-(void)authnticateUserWithGameCenter
{
    if([SKPaymentQueue canMakePayments]){
        NSLog(@"User can make payments");
        
        //If you have more than one in-app purchase, and would like
        //to have the user purchase a different product, simply define
        //another function and replace kRemoveAdsProductIdentifier with
        //the identifier for the other product
        
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"fuzzy_jade_bag"]];
        productsRequest.delegate = [GameCenter SharedGameCenter];
        [productsRequest start];
        
    }
    else{
        NSLog(@"User cannot make payments due to parental controls");
        //this is called the user cannot make payments, most likely due to parental controls
    }
    __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error)
    {
        if(viewController)
        {
            [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:viewController animated:YES completion:nil];
            UnitySendMessage("SocialPlugin","GameCenterLoginFailed","GameCenter is Disabled");
        }
        else if(localPlayer.isAuthenticated == YES)
        {
            [localPlayer generateIdentityVerificationSignatureWithCompletionHandler:^(NSURL *publicKeyUrl, NSData *signature, NSData *salt, uint64_t timestamp, NSError *error)
             {
                 
                 if(error != nil)
                 {
                     NSLog(@"some sort of error, can't authenticate right now %@", error);
                     UnitySendMessage("SocialPlugin","GameCenterLoginFailed",[[error localizedDescription] UTF8String]);
                     return; //some sort of error, can't authenticate right now
                 }
                 NSString *signatureAsString = [signature base64EncodedStringWithOptions:0];
                 NSString *saltAsString = [salt base64EncodedStringWithOptions:0];
                 NSString *timestampAsString = [[NSNumber numberWithUnsignedLongLong:timestamp] stringValue];
                 [self verifyPlayer:localPlayer.playerID publicKeyUrl:publicKeyUrl.absoluteString signature:signatureAsString salt:saltAsString timestamp:timestampAsString];
             }];
        }
        else
        {
            NSLog(@"game center disabled");
            UnitySendMessage("SocialPlugin","GameCenterLoginFailed","GameCenter is Disabled");
        }
    };
}

-(void)verifyPlayer:(NSString *)playerID publicKeyUrl:(NSString *)publicKeyUrl signature:(NSString *)signature salt:(NSString *)salt timestamp:(NSString*)timestamp
{
    NSLog(@"PlayerID %@ ", playerID);
    NSLog(@"publicKeyUrl %@ ", publicKeyUrl);
    NSLog(@"signature %@ ", signature);
    NSLog(@"salt %@ ", salt);
    NSLog(@"timestamp %@ ", timestamp);
    //join the strings to be sent to unity
    const char* concatnatedString = [[[[NSArray alloc] initWithObjects:playerID, publicKeyUrl, signature, salt, timestamp, nil] componentsJoinedByString:@"|"] UTF8String];
    UnitySendMessage("SocialPlugin","GameCenterLoginSuccess",concatnatedString);
}

+(GameCenter*) SharedGameCenter
{
    static GameCenter* sharedGameCenter = nil;
    if (sharedGameCenter == nil)
        sharedGameCenter = [[GameCenter alloc] init];
    return sharedGameCenter;
}

//if we are running on a test app, let's print the UnitySendMessage output
#if !UNITY_IOS
void UnitySendMessage(const char* gameObjectName, const char* methodeName, const char* parameter)
{
    printf("Invoking UnitySendMessage with \nGameObject name: %s \nmethode name: %s \nString parameter: %s", gameObjectName, methodeName, parameter);
}
#endif

@end

//native C functions that can be called from unity
extern "C"
{
    void authnticateUserWithGameCenter()
    {
        [[GameCenter SharedGameCenter] authnticateUserWithGameCenter];
    }
    
}
