//
//  User.h
//  TeamboxLite
//
//  Created by Xavi on 26/01/13.
//  Copyright (c) 2013 Sergi Gracia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lastName;

-(void) getUserDetails:(NSNumber *)userId;


@end