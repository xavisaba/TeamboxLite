//
//  ViewController.h
//  TeamboxLite
//
//  Created by Sergi Gracia on 13/12/12.
//  Copyright (c) 2012 Sergi Gracia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <RKOAuthClientDelegate>

- (void)authResponse:(NSString *)urlResponse;

@end
