//
//  TasksListViewController.h
//  TeamboxLite
//
//  Created by Sergi Gracia on 13/12/12.
//  Copyright (c) 2012 Sergi Gracia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCellViewController.h"

@interface TasksListViewController : UIViewController <RKObjectLoaderDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet TaskCellViewController *taskCell;
- (IBAction)newTaskButton:(id)sender;

@end
