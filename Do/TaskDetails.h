//
//  TaskDetails.h
//  Do
//
//  Created by Omar Ahmed on 29/01/2022.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import <CCDropDownMenus/CCDropDownMenus.h>

@interface TaskDetails : UIViewController <CCDropDownMenuDelegate>

@property Task*taskContainer;
@property NSInteger indexRow;



@end

