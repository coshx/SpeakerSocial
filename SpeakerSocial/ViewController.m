//
//  ViewController.m
//  SpeakerSocial
//
//  Created by Chielo Zimmerman on 3/26/13.
//  Copyright (c) 2013 Coshx Labs, Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)quoteButtonTapped:(id)sender{
    NSString *FeedURL=@"http://chielo.herokuapp.com/time";
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:FeedURL]];
    NSURLResponse *resp = nil;
    NSError *err = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest: theRequest returningResponse: &resp error: &err];
    NSString * the_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"response: %@", the_string);
    self.quoteText.text = [NSString stringWithFormat:@"get time response: %@",  the_string];

}


@end
