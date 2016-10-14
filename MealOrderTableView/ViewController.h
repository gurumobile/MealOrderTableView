//
//  ViewController.h
//  MealOrderTableView
//
//  Created by Bogdan Dimitrov Filov on 10/14/16.
//  Copyright © 2016 Bogdan Dimitrov Filov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableView.h"

@interface ViewController : UIViewController <CustomTableViewDataSource, CustomTableViewDelegate> {
    NSArray *cellTitles;
}

@property (weak, nonatomic) IBOutlet CustomTableView *mealTbl;

@end