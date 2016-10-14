//
//  CustomTableView.m
//  MealOrderTableView
//
//  Created by Bogdan Dimitrov Filov on 10/14/16.
//  Copyright © 2016 Bogdan Dimitrov Filov. All rights reserved.
//

#import "CustomTableView.h"

@implementation CustomTableView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        expandedIndexPaths = [NSMutableArray new];
    }
    return self;
}

/*
 *  This customize part is most important.
 */

#pragma mark -
#pragma mark -  Customize Datasource and Delegate Methods...

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_customTableViewDataSource tableView:tableView numberOfRowsInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_customTableViewDataSource numberOfSectionsInTableView:tableView];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([_customTableViewDataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)])
        
        return [_customTableViewDataSource tableView:tableView titleForHeaderInSection:section];
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {	if ([_customTableViewDataSource respondsToSelector:@selector(tableView:titleForFooterInSection:)])
    
        return [_customTableViewDataSource tableView:tableView titleForFooterInSection:section];
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_customTableViewDataSource respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)])
        
        return [_customTableViewDataSource tableView:tableView canEditRowAtIndexPath:indexPath];
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_customTableViewDataSource respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)])
        return [_customTableViewDataSource tableView:tableView canMoveRowAtIndexPath:indexPath];
    return NO;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if ([_customTableViewDataSource respondsToSelector:@selector(sectionIndexTitlesForTableView:)])
        return [_customTableViewDataSource sectionIndexTitlesForTableView:tableView];
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if ([_customTableViewDataSource respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)])
        return [_customTableViewDataSource tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
    return 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_customTableViewDataSource respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)])
        return [_customTableViewDataSource tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if ([_customTableViewDataSource respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)])
        return [_customTableViewDataSource tableView:tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell;
    
    if (self.expandOnlyOneCell) {
        if (actionToTake == 0) {
            if (selectedIndexPath)
                if (selectedIndexPath.row == indexPath.row && selectedIndexPath.section == indexPath.section) {
                    cell = [_customTableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath isExpanded:YES];//i want it expanded
                    return cell;
                }
            
            cell = [_customTableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath isExpanded:NO];
            
            return cell; //it's already collapsed!
        }
        
        cell = [_customTableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath isExpanded:NO];
        
        if(actionToTake == -1) {
            [_customTableViewDataSource tableView:tableView collapseCell:cell withIndexPath:indexPath];
            actionToTake = 0;
        } else {
            [_customTableViewDataSource tableView:tableView expandCell:cell withIndexPath:indexPath];
            actionToTake = 0;
        }
    } else {
        if (actionToTake == 0) {
            BOOL alreadyExpanded = NO;
            NSIndexPath* correspondingIndexPath;
            for (NSIndexPath* anIndexPath in expandedIndexPaths) {
                if (anIndexPath.row == indexPath.row && anIndexPath.section == indexPath.section)
                {alreadyExpanded = YES; correspondingIndexPath = anIndexPath;}
            }
            
            if (alreadyExpanded)
                cell = [_customTableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath isExpanded:YES];
            else
                cell = [_customTableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath isExpanded:NO];
            
            return cell; //it's already collapsed!
            
        }
        
        cell = [_customTableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath isExpanded:NO];
        
        if(actionToTake == -1) {
            [_customTableViewDataSource tableView:tableView collapseCell:cell withIndexPath:indexPath];
            actionToTake = 0;
        } else {
            [_customTableViewDataSource tableView:tableView expandCell:cell withIndexPath:indexPath];
            actionToTake = 0;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.expandOnlyOneCell) {
        if (selectedIndexPath)
            if(selectedIndexPath.row == indexPath.row && selectedIndexPath.section == indexPath.section)
                return [_customTableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath isExpanded:YES];
        
        return [_customTableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath isExpanded:NO];
    } else {
        BOOL alreadyExpanded = NO;
        NSIndexPath* correspondingIndexPath;
        for (NSIndexPath* anIndexPath in expandedIndexPaths) {
            if (anIndexPath.row == indexPath.row && anIndexPath.section == indexPath.section)
            {alreadyExpanded = YES; correspondingIndexPath = anIndexPath;}
        } if (alreadyExpanded)
            return [_customTableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath isExpanded:YES];
        else
            return [_customTableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath isExpanded:NO];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.expandOnlyOneCell) {
        if (selectedIndexPath)
            if (selectedIndexPath.row != -1 && selectedIndexPath.row != -2) {
                BOOL dontExpandNewCell = NO;
                
                if (selectedIndexPath.row == indexPath.row && selectedIndexPath.section == indexPath.section)
                    dontExpandNewCell = YES;
                
                NSIndexPath* tmp = [NSIndexPath indexPathForRow:selectedIndexPath.row inSection:selectedIndexPath.section];//tmp now holds the last expanded item
                selectedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
                
                actionToTake = -1;
                
                [tableView beginUpdates];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:tmp] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView endUpdates];
                
                if (dontExpandNewCell)
                    return;
            }
        
        actionToTake = 1;
        ///expand the new touched item
        
        selectedIndexPath = indexPath;
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        if (self.enableAutoScroll)
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
    } else {
        BOOL alreadyExpanded = NO;
        NSIndexPath* correspondingIndexPath;
        
        for (NSIndexPath* anIndexPath in expandedIndexPaths) {
            if (anIndexPath.row == indexPath.row && anIndexPath.section == indexPath.section)
            {alreadyExpanded = YES; correspondingIndexPath = anIndexPath;}
        }
        
        if (alreadyExpanded) {
            actionToTake = -1;
            [expandedIndexPaths removeObject:correspondingIndexPath];
            
            [tableView beginUpdates];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView endUpdates];
        } else {
            actionToTake = 1;
            [expandedIndexPaths addObject:indexPath];			
            [tableView beginUpdates];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView endUpdates];
            
            if (self.enableAutoScroll)
                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }
}

@end
