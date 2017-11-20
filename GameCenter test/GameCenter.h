//
//  GameCenter.h
//  GameCenter test
//
//  Created by Ahmad Alshebli on 6/22/16.
//  Copyright © 2016 PeopleCorpGaming. All rights reserved.
//

#ifndef GameCenter_h
#define GameCenter_h

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import <StoreKit/StoreKit.h>

@interface GameCenter : NSObject

//@property GameCenter* gameCenter;

+(GameCenter*)SharedGameCenter;
-(void)authnticateUserWithGameCenter;
-(void)verifyPlayer:(NSString *)playerID publicKeyUrl:(NSString *)publicKeyUrl signature:(NSString *)signature salt:(NSString *)salt timestamp:(NSString*)timestamp;

@end 

#endif /* GameCenter_h */
