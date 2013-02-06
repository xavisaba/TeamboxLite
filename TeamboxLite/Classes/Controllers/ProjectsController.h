//
//  ProjectsController.h
//  TeamboxLite
//
//  Created by Xavi on 02/02/13.
//  Copyright (c) 2013 Sergi Gracia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectsController : NSObject{
    NSMutableDictionary *projectsDic;
}
@property (nonatomic, retain) NSMutableDictionary *projectsDic;
+(ProjectsController*)getInstance;
-(void) loadProjectDetails:(NSNumber *)projectId;
-(NSString *) getName: (NSNumber *)projectId;
-(void) loadAllProjects;

@end
