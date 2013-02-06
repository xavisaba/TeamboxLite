//
//  UsersController.h
//  TeamboxLite
//
//  Created by Xavi on 04/02/13.
//  Copyright (c) 2013 Sergi Gracia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UsersController : NSObject{
    NSMutableDictionary *usersDic;
}
@property (nonatomic, retain) NSMutableDictionary *usersDic;
+(UsersController*)getInstance;
-(void) loadUserDetails:(NSNumber *)userId;
-(NSString *) getCompletName: (NSNumber *)userId;
-(void) loadAllUsers;

@end
