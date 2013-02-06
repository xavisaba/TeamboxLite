//
//  TaskCellViewController.h
//  TeamboxLite
//
//  Created by Sergi Gracia on 13/12/12.
//  Copyright (c) 2012 Sergi Gracia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCellViewController : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *taskName;
@property (nonatomic, weak) IBOutlet UIView *taskView;
@property (nonatomic, weak) IBOutlet UILabel *commentsCount;
@property (weak, nonatomic) IBOutlet UILabel *assignedUser;
@property (weak, nonatomic) IBOutlet UILabel *projectName;

- (void)showAnimation;

@end
