//
//  RoundsViewController.mm
//  LaserTag
//
//  Created by Matthew on 11/16/13.
//  Copyright (c) 2013 Andrew Shim. All rights reserved.
//

#import "RoundsViewController.h"
#import "SocketIO.h"
#import "SocketIOPacket.h"
@interface RoundsViewController ()

@end

@implementation RoundsViewController


static NSString* myName;
SocketIO * socketIO;
NSMutableArray* roundJSONArray;
+ (NSString*)myName { return myName; }

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet{
    
    NSLog(@"did receive event, data: %@", packet.data);
}
- (void) socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet
{
    NSLog(@"didReceiveMessage");
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    socketIO = [[SocketIO alloc] initWithDelegate:self];
    [socketIO connectToHost:@"localhost" onPort:3000];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [socketIO sendEvent:@"getActiveRounds" withData:dict];
    
    
    
    //Get initial rounds
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/activeRounds"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *urlResponse = nil;
    NSError *requestError;
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    roundJSONArray = [NSJSONSerialization JSONObjectWithData:response1 options:kNilOptions error:&requestError];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString* name = [textField text];
    myName = name;
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* roundJSON = [roundJSONArray objectAtIndex:indexPath.row];
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/activeRounds"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *urlResponse = nil;
    NSError *requestError;
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    return [roundJSONArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set the data for this cell:
    
//    cell.textLabel.text = [roundJSONArray objectAtIndex:indexPath.row];
    NSDictionary* roundObject = [roundJSONArray objectAtIndex:indexPath.row];
    NSString* roundName = [roundObject objectForKey:@"roundName"];
    NSLog(@"%@", roundObject);
    
    cell.textLabel.text = roundName;
    cell.detailTextLabel.text = @"More text";
    cell.imageView.image = [UIImage imageNamed:@"flower.png"];
    
    // set the accessory view:
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

@end
