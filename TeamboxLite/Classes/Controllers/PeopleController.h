//
//  PeopleController.h
//  TeamboxLite
//
//  Created by Xavi on 30/01/13.
//  Copyright (c) 2013 Sergi Gracia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PeopleController : NSObject{
    NSMutableDictionary *peopleDic;
}
@property (nonatomic, retain) NSMutableDictionary *peopleDic;
+(PeopleController*)getInstance;
-(void) loadPersonDetails:(NSNumber *)personId project:(NSNumber *)projectId;
-(NSNumber *) getUserId: (NSNumber *)personId project:(NSNumber *)projectId;
-(void) loadAllPeople;

@end
