//
//  TasksListViewController.m
//  TeamboxLite
//
//  Created by Sergi Gracia on 13/12/12.
//  Copyright (c) 2012 Sergi Gracia. All rights reserved.
//

#import "TasksListViewController.h"
#import "Task.h"

@interface TasksListViewController ()

@property (nonatomic, strong) NSArray *resultsArray;
@property (nonatomic, weak) IBOutlet UITableView *resultsTable;
@property (nonatomic, weak) IBOutlet UISegmentedControl *filterControl;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TasksListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Init navBar
    [self setTitle:@"Tasks"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"LogOut" style:UIBarButtonItemStyleBordered target:self action:@selector(logOut)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //Init Restkit
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:@"https://teambox.com"];
    manager = nil;
    
    //Set cache policy
    [[RKClient sharedClient] setCachePolicy:RKRequestCachePolicyEnabled];
    
    //Add refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor grayColor]];
    [self.refreshControl addTarget:self action:@selector(loadTasksList) forControlEvents:UIControlEventValueChanged];
    [self.resultsTable addSubview:self.refreshControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.refreshControl beginRefreshing];
    [self.resultsTable scrollRectToVisible:CGRectMake(0, -50, self.resultsTable.frame.size.width, 50) animated:YES];
    
    [self loadTasksList];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"wood_pattern.png"]]];
    [self.resultsTable setBackgroundColor:[UIColor clearColor]];
}

- (void)logOut
{
    NSLog(@"LogOut");
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userAccessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[[UIApplication sharedApplication] delegate] performSelector:@selector(logOut)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Download tasks list

- (void)loadTasksList
{
    // Perform a simple HTTP GET and call me back with the results
    NSString *urlGetTasks;
    
    switch (self.filterControl.selectedSegmentIndex) {
        case 0:
            urlGetTasks = [NSString stringWithFormat:@"/api/2/tasks?count=20&status=1&access_token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userAccessToken"]];
            break;
        case 1:
            urlGetTasks = [NSString stringWithFormat:@"/api/2/tasks?count=20&status=2&access_token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userAccessToken"]];
            break;
    }
    
    //Load objects from url
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[Task class]];
    
    //Set relations (keys)
    [objectMapping mapKeyPath:@"id" toAttribute:@"idObject"];
    [objectMapping mapKeyPath:@"name" toAttribute:@"name"];
    [objectMapping mapKeyPath:@"comments_count" toAttribute:@"commentsCount"];
    
    RKObjectManager* manager = [RKObjectManager sharedManager];
    
    [manager loadObjectsAtResourcePath:urlGetTasks delegate:self block:^(RKObjectLoader* loader){
        loader.objectMapping = objectMapping;
        [loader setCachePolicy:RKRequestCachePolicyNone];
    }];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [self.refreshControl endRefreshing];
    NSLog(@"%d Tasks received", objects.count);
    
    self.resultsArray = objects;
    [self.resultsTable reloadData];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [self.refreshControl endRefreshing];
    NSLog(@"Error: %@", error.description);
}

#pragma mark - Segmented Controller methods

-(IBAction) segmentedControlIndexChanged
{
    [self.refreshControl beginRefreshing];
    [self.resultsTable scrollRectToVisible:CGRectMake(0, 0, self.resultsTable.frame.size.width, 50) animated:YES];

    [self loadTasksList];
}

#pragma mark - Table methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Cell identifier must be the same of custom cell nib
    static NSString *CellIdentifierUser = @"TaslCellViewController";

    TaskCellViewController *cell = (TaskCellViewController *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierUser];

    if (cell == nil) {

        [[NSBundle mainBundle] loadNibNamed:@"TaskCellViewController" owner:self options:nil];
        cell = self.taskCell;
        self.taskCell = nil;
    }

    //Get current Task
    Task *currentTask = [self.resultsArray objectAtIndex:indexPath.row];
    
    [cell.taskName setText:currentTask.name];
    [cell.commentsCount setText:[NSString stringWithFormat:@"%d",[currentTask.commentsCount intValue]]];
    
    [cell showAnimation];
    
    return cell;
}

//- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UserProfile_VC *userProfileVC = [[UserProfile_VC alloc] initWithNibName:@"UserProfile_VC" bundle:nil];
//    
//    if (indexPath.section == 0){
//        //ME User
//        userProfileVC.idUser = [UserDataManager getUserDataForKey:@"idUser"];
//    }else{
//        User *oneFriend = [friendsTableData objectAtIndex:indexPath.row];
//        userProfileVC.idUser = oneFriend.idUser;
//    }
//    
//    [self.navigationController pushViewController:userProfileVC animated:YES];
//}

@end
