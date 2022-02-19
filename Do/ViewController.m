//
//  ViewController.m
//  Do
//
//  Created by Omar Ahmed on 27/01/2022.
//

#import "ViewController.h"
#import "AddTaskPage.h"
#import "Task.h"
#import "TaskDetails.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableViewDo;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end
AddTaskPage*addTask;
NSString*title;
NSMutableArray<Task*>*displayArr;
TaskDetails*td;
NSMutableArray*newarray;
NSUserDefaults*def;
NSMutableArray<Task*>*filteredDevices;
BOOL isFilter;
UIAlertController*alert;
UIAlertAction*cancel;
UIAlertAction*ok;
UIImageView*pic;
UILabel*tsknme;
UILabel*datename;
UIView*vw;
bool isGrandted;
@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    isGrandted=false;
    UNUserNotificationCenter *center=[UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options=UNAuthorizationOptionAlert+UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        isGrandted=granted;
    }];
    isFilter=NO;
    self.searchBar.delegate=self;
    
}

- (void)viewWillAppear:(BOOL)animated{
    printf("view will appear\n");
    def=[NSUserDefaults standardUserDefaults];
    NSError*error;
    NSData*dataBack=[def objectForKey:@"Tasks"];
    NSSet*sett=[NSSet setWithArray:@[[NSArray class],[Task class]]];
    displayArr=(NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:sett fromData:dataBack error:&error];
    [self.tableViewDo reloadData];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isFilter) {
        return filteredDevices.count;
    }
    return displayArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"TASKS";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    pic=[cell viewWithTag:2];
    tsknme=[cell viewWithTag:3];
    datename=[cell viewWithTag:4];
    vw=[cell viewWithTag:5];
    [cell addSubview:vw];
    if (isFilter) {
        tsknme.text=[filteredDevices[indexPath.row] taskName];
        datename.text=[NSDateFormatter localizedStringFromDate:[filteredDevices[indexPath.row] datee]
                                                                 dateStyle:NSDateFormatterShortStyle
                                                                 timeStyle:NSDateFormatterShortStyle];
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        if ([[filteredDevices[indexPath.row] prior] isEqual:@"High"]) {
            pic.image=[UIImage imageNamed:@"1"];
            

        }else if ([[filteredDevices[indexPath.row] prior] isEqual:@"Medium"]){
            pic.image=[UIImage imageNamed:@"90"];


        }else if ([[filteredDevices[indexPath.row] prior] isEqual:@"Low"]){
            pic.image=[UIImage imageNamed:@"3"];

        }
        
    }
    else{
        

    tsknme.text=[displayArr[indexPath.row] taskName];
    datename.text=[NSDateFormatter localizedStringFromDate:[displayArr[indexPath.row] datee]
                                                             dateStyle:NSDateFormatterShortStyle
                                                             timeStyle:NSDateFormatterShortStyle];
        
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if ([[displayArr[indexPath.row] prior] isEqual:@"High"]) {
        pic.image=[UIImage imageNamed:@"1"];
        

    }else if ([[displayArr[indexPath.row] prior] isEqual:@"Medium"]){
        pic.image=[UIImage imageNamed:@"90"];
        


    }else if ([[displayArr[indexPath.row] prior] isEqual:@"Low"]){
        pic.image=[UIImage imageNamed:@"3"];
        
    }
    }
    
        vw.layer.cornerRadius=30;
        vw.layer.shadowColor=[UIColor blackColor].CGColor;
        vw.layer.shadowRadius=3;
        vw.layer.shadowOpacity=0.5;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        alert=[UIAlertController alertControllerWithTitle:@"Delete Task" message:@"Are you sure that you want to delete?" preferredStyle:UIAlertControllerStyleAlert];
        cancel=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL];
        ok=[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [displayArr removeObjectAtIndex:indexPath.row];
            NSData*dd=[NSKeyedArchiver archivedDataWithRootObject:displayArr requiringSecureCoding:YES error:NULL];
            [def setObject:dd forKey:@"Tasks"];
            [self.tableViewDo reloadData];
        }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:NULL];


//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    td=[self.storyboard instantiateViewControllerWithIdentifier:@"taskdetail"];
    [td setTaskContainer:displayArr[indexPath.row]];
    [td setIndexRow:indexPath.row];
    [self.navigationController pushViewController:td  animated:YES];

}



- (IBAction)addTaskBtn:(id)sender {
    addTask=[self.storyboard instantiateViewControllerWithIdentifier:@"addpage"];
    [self.navigationController pushViewController:addTask animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    if (searchText.length == 0) {
        isFilter = NO;
    }
    else {
        isFilter = YES;
        filteredDevices = [[NSMutableArray alloc]init];
        for (int i=0; i<displayArr.count; i++) {
            if ([displayArr[i].taskName hasPrefix:searchText] || [displayArr[i].taskName hasPrefix:[searchText lowercaseString]]) {
                    [filteredDevices addObject:displayArr[i]];
            }
        }
    }
    [self.tableViewDo reloadData];
}


@end
