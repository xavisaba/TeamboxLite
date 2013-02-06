//
//  PeopleController.m
//  TeamboxLite
//
//  Created by Xavi on 30/01/13.
//  Copyright (c) 2013 Sergi Gracia. All rights reserved.
//

#import "PeopleController.h"
#import "Person.h"
#import "UsersController.h"


@interface PeopleController()
@end
@implementation PeopleController

@synthesize peopleDic;
static PeopleController *peopleController=nil;

+(PeopleController*)getInstance {
    
    @synchronized(self){
        if(peopleController == nil){
            peopleController = [[super allocWithZone:NULL] init];
        }
        
        return peopleController;
    }
}

- (id)init {
    if (self = [super init]) {
        peopleDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}



-(void) loadPersonDetails:(NSNumber *)personId project:(NSNumber *)projectId{
    [self loadPersonAssigned:personId project:projectId];
}

-(void) loadAllPeople{
    [self loadPeople];
}

-(void) loadPeople
{
    NSString *urlGetUser;
    urlGetUser = [NSString stringWithFormat:@"/api/2/people?access_token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userAccessToken"]];
        
    NSLog(@"urlGetUser: %@",urlGetUser);
        //Load objects from url
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[Person class]];
            
    //Set relations (keys)
    [objectMapping mapKeyPath:@"id" toAttribute:@"personId"];
    [objectMapping mapKeyPath:@"user_id" toAttribute:@"userId"];
    [objectMapping mapKeyPath:@"project_id" toAttribute:@"projectId"];
        
    RKObjectManager* manager = [RKObjectManager sharedManager];
        
    [manager loadObjectsAtResourcePath:urlGetUser delegate:self block:^(RKObjectLoader* loader){
        loader.objectMapping = objectMapping;
        [loader sendSynchronously];
        [loader setCachePolicy:RKRequestCachePolicyDefault];
    }];
}

-(void) loadPersonAssigned:(NSNumber *)personId project:(NSNumber *)projectId
{
    if (![self existInDic:personId project:projectId]){
        
    
        NSString *urlGetUser;
        urlGetUser = [NSString stringWithFormat:@"/api/2/projects/%@/people/%@?access_token=%@", projectId,personId,[[NSUserDefaults standardUserDefaults] objectForKey:@"userAccessToken"]];
    
        NSLog(@"urlGetUser: %@",urlGetUser);
        //Load objects from url
        RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[Person class]];
        /*RKObjectMapping *objectsUser = [RKObjectMapping mappingForClass:[User class]];
        [objectsUser mapKeyPath:@"id" toAttribute:@"userId"];
        [objectsUser mapKeyPath:@"first_name" toAttribute:@"name"];
        [objectsUser mapKeyPath:@"last_name" toAttribute:@"lastName"];
         */
        //Set relations (keys)
        [objectMapping mapKeyPath:@"id" toAttribute:@"personId"];
        [objectMapping mapKeyPath:@"user_id" toAttribute:@"userId"];
        [objectMapping mapKeyPath:@"project_id" toAttribute:@"projectId"];
    
        /*RKObjectRelationshipMapping *relation = [RKObjectRelationshipMapping mappingFromKeyPath:@"user" toKeyPath:@"user" withMapping: objectsUser];
        [objectMapping addRelationshipMapping:relation];
        */
        RKObjectManager* manager = [RKObjectManager sharedManager];
    
        [manager loadObjectsAtResourcePath:urlGetUser delegate:self block:^(RKObjectLoader* loader){
            loader.objectMapping = objectMapping;
            [loader sendSynchronously];
            [loader setCachePolicy:RKRequestCachePolicyDefault];
        }];
    }
}

-(NSNumber *) getUserId: (NSNumber *)personId project:(NSNumber *)projectId{
    NSString *key= [NSString stringWithFormat:@"%@-%@",projectId,personId];
    Person *p= [[[PeopleController getInstance]peopleDic] objectForKey:key];
    return p.userId;
}

-(bool) existInDic:(NSNumber *)personId project:(NSNumber *)projectId{
    NSString *key= [NSString stringWithFormat:@"%@-%@",projectId,personId];
    if ([[[PeopleController getInstance]peopleDic] objectForKey:key]==nil) {
        return false;
    }
    return true;
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSLog(@"People recived: %d",objects.count);
    NSArray *result = objects;
    for (Person *p in result){
        NSString *key= [NSString stringWithFormat:@"%@-%@",p.projectId,p.personId];
        if (![self existInDic:p.personId project:p.projectId]) {
            [[[PeopleController getInstance]peopleDic] setObject:p forKey:key];
            [[UsersController getInstance] loadUserDetails:p.userId];
        }
    }
    
}


- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    //    [self.refreshControl endRefreshing];
    //    NSLog(@"Error: %@", error.description);
}


@end
