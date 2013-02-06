//
//  UsersController.m
//  TeamboxLite
//
//  Created by Xavi on 04/02/13.
//  Copyright (c) 2013 Sergi Gracia. All rights reserved.
//

#import "UsersController.h"
#import "User.h"

@interface UsersController()
@end
@implementation UsersController

@synthesize usersDic;
static UsersController *usersController=nil;

+(UsersController*)getInstance {
    
    @synchronized(self){
        if(usersController == nil){
            usersController = [[super allocWithZone:NULL] init];
        }
        
        return usersController;
    }
}

- (id)init {
    if (self = [super init]) {
        usersDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}



-(void) loadUserDetails:(NSNumber *)userId{
    [self loadUser:userId];
}

-(void) loadAllUsers{
    [self loadUsers];
}

-(void) loadUsers{
    NSString *urlGetUsers;
    urlGetUsers = [NSString stringWithFormat:@"/api/2/users?access_token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userAccessToken"]];
    
    NSLog(@"urlGetUsers: %@",urlGetUsers);
    //Load objects from url
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[User class]];
    [objectMapping mapKeyPath:@"id" toAttribute:@"userId"];
    [objectMapping mapKeyPath:@"first_name" toAttribute:@"name"];
    [objectMapping mapKeyPath:@"last_name" toAttribute:@"lastName"];
    
    RKObjectManager* manager = [RKObjectManager sharedManager];
    
    [manager loadObjectsAtResourcePath:urlGetUsers delegate:self block:^(RKObjectLoader* loader){
        loader.objectMapping = objectMapping;
        [loader sendSynchronously];
        [loader setCachePolicy:RKRequestCachePolicyDefault];
    }];
    
}

-(void) loadUser:(NSNumber *)userId
{
    if (![self existInDic:userId]){
        
        
        NSString *urlGetUsers;
        urlGetUsers = [NSString stringWithFormat:@"/api/2/users/%@?access_token=%@", userId,[[NSUserDefaults standardUserDefaults] objectForKey:@"userAccessToken"]];
        
        NSLog(@"urlGetUsers: %@",urlGetUsers);
        //Load objects from url
        RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[User class]];
        [objectMapping mapKeyPath:@"id" toAttribute:@"userId"];
        [objectMapping mapKeyPath:@"first_name" toAttribute:@"name"];
        [objectMapping mapKeyPath:@"last_name" toAttribute:@"lastName"];
        
        RKObjectManager* manager = [RKObjectManager sharedManager];
        
        [manager loadObjectsAtResourcePath:urlGetUsers delegate:self block:^(RKObjectLoader* loader){
            loader.objectMapping = objectMapping;
            [loader sendSynchronously];
            [loader setCachePolicy:RKRequestCachePolicyDefault];
        }];
    }
}

-(NSString *) getCompletName: (NSNumber *)userId{
    NSString *key= [NSString stringWithFormat:@"%@",userId];
    if ([[[UsersController getInstance]usersDic] objectForKey:key]!=nil) {
        User *u=[[[UsersController getInstance]usersDic] objectForKey:key];
        NSString *value= [NSString stringWithFormat:@"%@ %@",u.name,u.lastName];
        return value;
    }
    return @"not exist";
}

-(bool) existInDic:(NSNumber *)userId{
    NSString *key= [NSString stringWithFormat:@"%@",userId];
    if ([[[UsersController getInstance]usersDic] objectForKey:key]==nil) {
        return false;
    }
    return true;
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSLog(@"Users recived: %d",objects.count);
    NSArray *result = objects;
    for (User *u in result){
        NSString *key= [NSString stringWithFormat:@"%@",u.userId];
        if (![self existInDic:key]) {
            [[[UsersController getInstance]usersDic] setObject:u forKey:key];
        }
    }
    
    
}


- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    //    [self.refreshControl endRefreshing];
    //    NSLog(@"Error: %@", error.description);
}


@end
