//
//  LoginObject.h
//  TeamboxLite
//
//  Created by Sergi Gracia on 13/12/12.
//  Copyright (c) 2012 Sergi Gracia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginObject : NSObject

@property (nonatomic, copy) NSString *scope;
@property (nonatomic, copy) NSString *access_token;

@end
