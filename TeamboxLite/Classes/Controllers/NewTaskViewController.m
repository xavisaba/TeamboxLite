//
//  NewTaskViewController.m
//  TeamboxLite
//
//  Created by Xavi on 06/02/13.
//  Copyright (c) 2013 Sergi Gracia. All rights reserved.
//

#import "NewTaskViewController.h"
#import "ProjectsController.h"
#import "Project.h"
#import "PeopleController.h"
#import "Person.h"
#import "UsersController.h"

@interface NewTaskViewController ()

@end

@implementation NewTaskViewController

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
    [self setTitle:@"New Task"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setHidesBackButton:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];
    
    [self loadLabels];
    [self loadFields];
    //load arrays
    if(arrayPickerElements==nil || arrayProjects==nil){
        arrayPickerElements= [[NSMutableArray alloc]init];
        arrayProjects=[[NSMutableArray alloc]init];
        [self loadProjects];
    }
    if(arrayPickerElements==nil || arrayPeople==nil){
        arrayPickerElements= [[NSMutableArray alloc]init];
        arrayPeople=[[NSMutableArray alloc]init];
        [self loadPeople];
    }
    [self loadPicker];
    UIToolbar *createToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,self.navigationController.toolbar.frame.origin.y - self.navigationController.toolbar.frame.size.height-64,self.view.frame.size.width, 44)];
    createToolBar.barStyle = UIBarStyleBlackTranslucent;
    createToolBar.tintColor=[UIColor darkGrayColor];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *createBtn = [[UIBarButtonItem alloc] initWithTitle:@"Create task" style:UIBarButtonItemStyleBordered target:self action:@selector(createTask)];
    createBtn.tintColor=[UIColor grayColor];
    [barItems addObject:createBtn];
    [barItems addObject:flexSpace];
    [createToolBar setItems:barItems animated:YES];
    
    [self.view addSubview:createToolBar];
}

-(void)createTask{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"wood_pattern.png"]]];
}

-(void)loadProjects{
    [[ProjectsController getInstance]loadAllProjects];
    NSArray *keys = [[[ProjectsController getInstance] projectsDic] allKeys];
    for (NSString *key in keys){
        Project *p=[[[ProjectsController getInstance] projectsDic] objectForKey:key];
        [arrayProjects addObject:[[NSString alloc]initWithFormat:@"%@ (%@)",p.name,key]];
    }
}

-(NSString *) getProjectId: (NSString *)completString{
    //NSLog(@"Complete string %@",completString);
    NSArray *substrings = [completString componentsSeparatedByString:@"("];
    NSString *r = substrings[1];
    substrings = [r componentsSeparatedByString:@")"];
    //NSLog(@"%@",substrings[0]);
    return substrings[0];
}

-(void)loadPeople{
    [arrayPeople removeAllObjects];
    [[PeopleController getInstance]loadAllPeople];
    NSArray *keys = [[[PeopleController getInstance] peopleDic] allKeys];
    for (NSString *key in keys){
        Person *p=[[[PeopleController getInstance] peopleDic] objectForKey:key];
        if (projectField.text == nil) {
            [arrayPeople addObject:[[NSString alloc]initWithFormat:@"%@ (%@)",[[UsersController getInstance] getCompletName:p.userId],p.personId]];
        }else{
            if ([[p.projectId stringValue]  isEqualToString: [self getProjectId:projectField.text]]) {
                [arrayPeople addObject:[[NSString alloc]initWithFormat:@"%@ (%@)",[[UsersController getInstance] getCompletName:p.userId],p.personId]];
            }
        }
    }
}

-(void)loadLabels
{
    //TASK NAME
    UILabel *taskNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    [taskNameLabel setBackgroundColor:[UIColor clearColor]];
    [taskNameLabel setTextColor:[UIColor darkGrayColor]];
    [taskNameLabel setText:@"Task name"];
    [[self view] addSubview:taskNameLabel];
    
    //PROJECT ASSIGNED
    UILabel *projectLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 100, 30)];
    [projectLabel setBackgroundColor:[UIColor clearColor]];
    [projectLabel setTextColor:[UIColor darkGrayColor]];
    [projectLabel setText:@"Project"];
    [[self view] addSubview:projectLabel];
    
    //PROJECT ASSIGNED
    UILabel *personLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 100, 30)];
    [personLabel setBackgroundColor:[UIColor clearColor]];
    [personLabel setTextColor:[UIColor darkGrayColor]];
    [personLabel setText:@"Person"];
    [[self view] addSubview:personLabel];
}

-(void) loadFields
{
    //TASK NAME
    taskNameField = [[UITextField alloc]initWithFrame:CGRectMake(110, 10, 200, 30)];
    [taskNameField setBorderStyle:UITextBorderStyleRoundedRect];
    taskNameField.delegate=self;
    [self.view addSubview:taskNameField];
    
    //PROJECT FIELD
    projectField = [[UITextField alloc]initWithFrame:CGRectMake(110, 45, 200, 30)];
    [projectField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:projectField];
    
    //PERSON FIELD
    personField = [[UITextField alloc]initWithFrame:CGRectMake(110, 80, 200, 30)];
    [personField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:personField];

}
-(void) loadPicker
{
    projectPicker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    projectPicker.delegate =self;
    projectPicker.dataSource = self;
    [projectPicker setShowsSelectionIndicator:YES];
    projectField.inputView = projectPicker;
    
    peoplePicker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    peoplePicker.delegate =self;
    peoplePicker.dataSource = self;
    [peoplePicker setShowsSelectionIndicator:YES];
    personField.inputView = peoplePicker;

    
    UIToolbar*  mypickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    mypickerToolbar.barStyle = UIBarStyleBlackTranslucent;
    mypickerToolbar.tintColor=[UIColor darkGrayColor];
    [mypickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked)];
    doneBtn.tintColor=[UIColor grayColor];
    [barItems addObject:doneBtn];
    [mypickerToolbar setItems:barItems animated:YES];
    projectField.inputAccessoryView = mypickerToolbar;
    personField.inputAccessoryView = mypickerToolbar;
}

-(void)pickerDoneClicked
{
    [projectField resignFirstResponder];
    [personField resignFirstResponder];
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([pickerView isEqual: projectPicker]){
        arrayPickerElements=arrayProjects;
        
    }else if([pickerView isEqual: peoplePicker]){

        arrayPickerElements=arrayPeople;
    }
    return arrayPickerElements.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [arrayPickerElements objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([pickerView isEqual: projectPicker]){
        projectField.text = (NSString *)[arrayProjects objectAtIndex:row];
        personField.text=nil;
        [self loadPeople];
    }else if([pickerView isEqual: peoplePicker]){
        personField.text = (NSString *)[arrayPeople objectAtIndex:row];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return TRUE;
}

@end
