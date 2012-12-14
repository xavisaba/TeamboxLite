//
//  Task.h
//  TeamboxLite
//
//  Created by Sergi Gracia on 13/12/12.
//  Copyright (c) 2012 Sergi Gracia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property (nonatomic, strong) NSNumber *idObject;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *commentsCount;

@end
