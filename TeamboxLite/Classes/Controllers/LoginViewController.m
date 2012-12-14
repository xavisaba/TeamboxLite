//
//  ViewController.m
//  TeamboxLite
//
//  Created by Sergi Gracia on 13/12/12.
//  Copyright (c) 2012 Sergi Gracia. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginObject.h"
#import "TasksListViewController.h"

#define APP_TEAMBOX_ID          @"HXZTFQnj8z9pqdwAvKQps9hzGkiM3VF8zQvMVthQ"
#define APP_TEAMBOX_SECRET      @"tXoWEvBqCwYcK41udM0pY5Nvy6hfIqSLYGlwr4Pe"
#define APP_TEAMBOX_CALLBACKURL @"http://sergigracia.com/myFiles/teambox.php"

@interface LoginViewController ()

@property (nonatomic, strong) RKOAuthClient *oauth2Client;

@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loginActivityIndicator;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendAuth:(id)sender
{
    [self.loginButton setAlpha:0];
    [self.loginActivityIndicator startAnimating];
    
    NSString *authUrl = [NSString stringWithFormat:
                         @"https://teambox.com/oauth/authorize?client_id=%@&redirect_uri=%@&response_type=code&scope=read_projects",
                         APP_TEAMBOX_ID,
                         APP_TEAMBOX_CALLBACKURL];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[authUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
}

- (void)authResponse:(NSString *)urlResponse
{
    NSString *responseCode = [urlResponse substringFromIndex:20];
    [self sendLogin:responseCode];
}

- (void)sendLogin:(NSString *)code
{
    NSLog(@"Validate OAuth with code: %@", code);
    
    NSString *urlAuth = @"https://teambox.com/oauth/token?";
    
    self.oauth2Client = [RKOAuthClient clientWithClientID:APP_TEAMBOX_ID secret:APP_TEAMBOX_SECRET delegate:self];
    [self.oauth2Client setAuthorizationURL:urlAuth];
    [self.oauth2Client setAuthorizationCode:code];
    [self.oauth2Client setCallbackURL:APP_TEAMBOX_CALLBACKURL];
    [self.oauth2Client validateAuthorizationCode];
    [[RKClient sharedClient].requestQueue setSuspended:NO];
}

- (void)OAuthClient:(RKOAuthClient *)client didAcquireAccessToken:(NSString *)token
{
    NSLog(@"Access Token Acquired: %@",token);
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"userAccessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    TasksListViewController *tasksListVC = [[TasksListViewController alloc] initWithNibName:@"TasksListViewController" bundle:nil];
    [self.navigationController pushViewController:tasksListVC animated:YES];
}

- (void)OAuthClient:(RKOAuthClient *)client didFailLoadingRequest:(RKRequest *)request withError:(NSError *)error
{
    NSLog(@"Error: %@",[error debugDescription]);
    [self.loginButton setAlpha:1];
    [self.loginActivityIndicator stopAnimating];
}

- (void)OAuthClient:(RKOAuthClient *)client didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@",[error debugDescription]);
    [self.loginButton setAlpha:1];
    [self.loginActivityIndicator stopAnimating];
}

- (void)OAuthClient:(RKOAuthClient *)client didFailWithInvalidGrantError:(NSError *)error
{
    NSLog(@"Error: %@",[error debugDescription]);
    [self.loginButton setAlpha:1];
    [self.loginActivityIndicator stopAnimating];
}

@end
