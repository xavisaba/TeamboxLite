//
//  ProjectsController.m
//  TeamboxLite
//
//  Created by Xavi on 02/02/13.
//  Copyright (c) 2013 Sergi Gracia. All rights reserved.
//

#import "ProjectsController.h"
#import "Project.h"

@interface ProjectsController()
@end
@implementation ProjectsController

@synthesize projectsDic;
static ProjectsController *projectsController=nil;

+(ProjectsController*)getInstance {
    
    @synchronized(self){
        if(projectsController == nil){
            projectsController = [[super allocWithZone:NULL] init];
        }
        
        return projectsController;
    }
}

- (id)init {
    if (self = [super init]) {
        projectsDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}



-(void) loadProjectDetails:(NSNumber *)projectId{
    [self loadProject:projectId];
}

-(void) loadAllProjects{
    [self loadProjects];
}

-(void) loadProjects{
    NSString *urlGetProjets;
    urlGetProjets = [NSString stringWithFormat:@"/api/2/projects?access_token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userAccessToken"]];
    
    NSLog(@"urlGetProject: %@",urlGetProjets);
    //Load objects from url
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[Project class]];
    [objectMapping mapKeyPath:@"id" toAttribute:@"projectId"];
    [objectMapping mapKeyPath:@"name" toAttribute:@"name"];
    
    RKObjectManager* manager = [RKObjectManager sharedManager];
    
    [manager loadObjectsAtResourcePath:urlGetProjets delegate:self block:^(RKObjectLoader* loader){
        loader.objectMapping = objectMapping;
        [loader sendSynchronously];
        [loader setCachePolicy:RKRequestCachePolicyDefault];
    }];

}

-(void) loadProject:(NSNumber *)projectId
{
    if (![self existInDic:projectId]){
        
        
        NSString *urlGetProjets;
        urlGetProjets = [NSString stringWithFormat:@"/api/2/projects/%@?access_token=%@", projectId,[[NSUserDefaults standardUserDefaults] objectForKey:@"userAccessToken"]];
        
        NSLog(@"urlGetProject: %@",urlGetProjets);
        //Load objects from url
        RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[Project class]];
        [objectMapping mapKeyPath:@"id" toAttribute:@"projectId"];
        [objectMapping mapKeyPath:@"name" toAttribute:@"name"];
        
        RKObjectManager* manager = [RKObjectManager sharedManager];
        
        [manager loadObjectsAtResourcePath:urlGetProjets delegate:self block:^(RKObjectLoader* loader){
            loader.objectMapping = objectMapping;
            [loader sendSynchronously];
            [loader setCachePolicy:RKRequestCachePolicyDefault];
        }];
    }
}

-(NSString *) getName: (NSNumber *)projectId{
    NSString *key= [NSString stringWithFormat:@"%@",projectId];
    if ([[[ProjectsController getInstance]projectsDic] objectForKey:key]!=nil) {
        Project *p=[[[ProjectsController getInstance]projectsDic] objectForKey:key];
        NSString *value= p.name;
        return value;
    }
    return @"not exist";
}

-(bool) existInDic:(NSNumber *)projectId{
    NSString *key= [NSString stringWithFormat:@"%@",projectId];
    if ([[[ProjectsController getInstance]projectsDic] objectForKey:key]==nil) {
        return false;
    }
    return true;
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSLog(@"Projects recived: %d",objects.count);
    NSArray *result = objects;
    for (Project *p in result){
        NSString *key= [NSString stringWithFormat:@"%@",p.projectId];
        if (![self existInDic:key]) {
            NSLog(@"-----------------Project cargado: %@-%@", p.projectId,p.name);
            [[[ProjectsController getInstance]projectsDic] setObject:p forKey:key];
        }
    }

    
}


- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    //    [self.refreshControl endRefreshing];
    //    NSLog(@"Error: %@", error.description);
}


@end
