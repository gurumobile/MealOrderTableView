//
//  ViewController.m
//  MealOrderTableView
//
//  Created by Bogdan Dimitrov Filov on 10/14/16.
//  Copyright © 2016 Bogdan Dimitrov Filov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mealTbl.customTableViewDataSource = self;
    self.mealTbl.customTableViewDelegate = self;
    
    cellTitles = @[@"Twitowie", @"Bill Greyskull", @"Moonglampers", @"Psit", @"Duncan WJ Palmer", @"Sajuma", @"Victor_lee", @"Jugger-naut", @"Javiersanagustin", @"Velouria!"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView expandCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:3];
    UIButton *purchaseButton = (UIButton *)[cell viewWithTag:10];
    purchaseButton.alpha = 0;
    purchaseButton.hidden = NO;
    
    [UIView animateWithDuration:.5 animations:^{
        detailLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
        purchaseButton.alpha = 1;
        [cell.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(3.14);
    }];
}

- (void)tableView:(UITableView *)tableView collapseCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:3];
    UIButton *purchaseButton = (UIButton *)[cell viewWithTag:10];
    
    [UIView animateWithDuration:.5 animations:^{
        detailLabel.text = @"Lorem ipsum dolor sit amet";
        purchaseButton.alpha = 0;
        [cell.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(-3.14);
    } completion:^(BOOL finished) {
        purchaseButton.hidden = YES;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isexpanded {
    if (isexpanded)
        return 120;
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isExpanded {
    static NSString *CellIdentifier = @"Content1";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    UILabel *textLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:3];
    UIButton *purchaseButton = (UIButton *)[cell viewWithTag:10];
    
    //alternative background colors for better division ;)
    if (indexPath.row %2 ==1)
        cell.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
    else
        cell.backgroundColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1];
    
    textLabel.text = [cellTitles objectAtIndex:indexPath.row % 10];
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString* imageFileName = [NSString stringWithFormat:@"%ld.jpg", indexPath.row % 10 + 1];
    imageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", bundlePath, imageFileName]];
    
    if (!isExpanded) {
        detailLabel.text = @"Lorem ipsum dolor sit amet";
        [cell.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(0);
        
        purchaseButton.hidden = YES;
    } else {
        detailLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
        [cell.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(3.14);
        
        purchaseButton.hidden = NO;
    }
    return cell;
}

@end