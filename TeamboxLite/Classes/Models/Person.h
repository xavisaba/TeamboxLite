//
//  Person.h
//  TeamboxLite
//
//  Created by Xavi on 30/01/13.
//  Copyright (c) 2013 Sergi Gracia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Person : NSObject
@property (nonatomic, strong) NSNumber *personId;
@property (nonatomic, strong) NSNumber *projectId;
@property (nonatomic, strong) NSNumber *userId;
//@property (nonatomic, strong) User *user;

@end
