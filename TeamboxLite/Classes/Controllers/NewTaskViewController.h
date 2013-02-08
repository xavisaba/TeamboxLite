//
//  NewTaskViewController.h
//  TeamboxLite
//
//  Created by Xavi on 06/02/13.
//  Copyright (c) 2013 Sergi Gracia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTaskViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>{

    IBOutlet UIPickerView *projectPicker;
    IBOutlet UIPickerView *peoplePicker;
    
    NSMutableArray *arrayPickerElements;
    NSMutableArray *arrayProjects;
    NSMutableArray *arrayPeople;
    
    IBOutlet UITextField *taskNameField;
    IBOutlet UITextField *projectField;
    IBOutlet UITextField *personField;
}


@end
