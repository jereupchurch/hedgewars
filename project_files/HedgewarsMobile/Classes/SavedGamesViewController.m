/*
 * Hedgewars-iOS, a Hedgewars port for iOS devices
 * Copyright (c) 2009-2010 Vittorio Giovara <vittorio.giovara@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * File created on 22/09/2010.
 */


#import "SavedGamesViewController.h"
#import "SDL_uikitappdelegate.h"
#import "CommodityFunctions.h"

@implementation SavedGamesViewController
@synthesize tableView, listOfSavegames;

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    return rotationManager(interfaceOrientation);
}

-(void) updateTable {
    NSArray *contentsOfDir = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:SAVES_DIRECTORY() error:NULL];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:contentsOfDir copyItems:YES];
    self.listOfSavegames = array;
    [array release];

    [self.tableView reloadData];
}

-(void) viewDidLoad {
    self.tableView.backgroundView = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewWillAppear:)
                                                 name:@"removedSave"
                                               object:nil];
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateTable];
}

#pragma mark -
#pragma mark button functions
-(IBAction) buttonPressed:(id) sender {
    playSound(@"backSound");
    [self.tableView setEditing:NO animated:YES];
    [[self parentViewController] dismissModalViewControllerAnimated:YES];
}

-(IBAction) toggleEdit:(id) sender {
    BOOL isEditing = self.tableView.editing;
    [self.tableView setEditing:!isEditing animated:YES];
    UIToolbar *toolbar = (UIToolbar *)[self.view viewWithTag:458912];
    for (UIBarButtonItem *item in toolbar.items)
        if (item.tag == 452198)
            item.enabled = !isEditing;
}

-(IBAction) clearAll:(id) sender {
    [[NSFileManager defaultManager] removeItemAtPath:SAVES_DIRECTORY() error:NULL];
    [[NSFileManager defaultManager] createDirectoryAtPath:SAVES_DIRECTORY() withIntermediateDirectories:NO attributes:nil error:NULL];
    [self updateTable];
}

#pragma mark -
#pragma mark Table view data source
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listOfSavegames count];
}

-(UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";

    EditableCellView *editableCell = (EditableCellView *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (editableCell == nil) {
        editableCell = [[[EditableCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        editableCell.delegate = self;
    }
    editableCell.tag = [indexPath row];
    editableCell.respectEditing = YES;
    editableCell.textField.text = [[self.listOfSavegames objectAtIndex:[indexPath row]] stringByDeletingPathExtension];
    editableCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIImage *addImg = [UIImage imageWithContentsOfFile:@"plus.png"];
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    customButton.tag = [indexPath row];
    [customButton setImage:addImg forState:UIControlStateNormal];
    [customButton addTarget:self action:@selector(duplicateEntry:) forControlEvents:UIControlEventTouchUpInside];
    editableCell.editingAccessoryView = customButton;

    return (UITableViewCell *)editableCell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger) section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    footer.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width*80/100, 100)];
    label.center = CGPointMake(self.tableView.frame.size.width/2,70);
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor lightGrayColor];
    label.numberOfLines = 5;
    label.text = NSLocalizedString(@"Games are automatically saved and can be resumed by selecting an entry above.\nYou can modify this list by pressing the 'Edit' button.\nNotice that completed games are deleted, so make backups.",@"");

    label.backgroundColor = [UIColor clearColor];
    [footer addSubview:label];
    [label release];
    return [footer autorelease];
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    [(EditableCellView *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]] save:nil];
    
    NSString *saveName = [self.listOfSavegames objectAtIndex:row];
    NSString *currentFilePath = [NSString stringWithFormat:@"%@/%@",SAVES_DIRECTORY(),saveName];
    [[NSFileManager defaultManager] removeItemAtPath:currentFilePath error:nil];
    [self.listOfSavegames removeObject:saveName];
    
    [self.tableView reloadData];
}

-(void) duplicateEntry:(id) sender {
    UIButton *button = (UIButton *)sender;
    NSUInteger row = button.tag;
    
    [(EditableCellView *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]] save:nil];
    NSString *currentSaveName = [self.listOfSavegames objectAtIndex:row];
    NSString *newSaveName = [[currentSaveName stringByDeletingPathExtension] stringByAppendingFormat:@" %d.hws",[self.listOfSavegames count]];
    
    NSString *currentFilePath = [NSString stringWithFormat:@"%@/%@",SAVES_DIRECTORY(),currentSaveName];
    NSString *newFilePath = [NSString stringWithFormat:@"%@/%@",SAVES_DIRECTORY(),newSaveName];
    [[NSFileManager defaultManager] copyItemAtPath:currentFilePath toPath:newFilePath error:nil];
    [self.listOfSavegames addObject:newSaveName];
    [self.listOfSavegames sortUsingSelector:@selector(compare:)];

    //[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.listOfSavegames indexOfObject:newSaveName] inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view delegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [(EditableCellView *)[self.tableView cellForRowAtIndexPath:indexPath] save:nil];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",SAVES_DIRECTORY(),[self.listOfSavegames objectAtIndex:[indexPath row]]];
    
    NSDictionary *allDataNecessary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSDictionary dictionary],@"game_dictionary",
                                      filePath,@"savefile",
                                      [NSNumber numberWithBool:NO],@"netgame",
                                      nil];
    [[SDLUIKitDelegate sharedAppDelegate] startSDLgame:allDataNecessary];
}

#pragma mark -
#pragma mark editableCellView delegate
// rename old file if names differ
-(void) saveTextFieldValue:(NSString *)textString withTag:(NSInteger) tagValue {
    NSString *oldFilePath = [NSString stringWithFormat:@"%@/%@",SAVES_DIRECTORY(),[self.listOfSavegames objectAtIndex:tagValue]];
    NSString *newFilePath = [NSString stringWithFormat:@"%@/%@.hws",SAVES_DIRECTORY(),textString];
    
    if ([oldFilePath isEqualToString:newFilePath] == NO) {
        [[NSFileManager defaultManager] moveItemAtPath:oldFilePath toPath:newFilePath error:nil];
        [self.listOfSavegames replaceObjectAtIndex:tagValue withObject:[textString stringByAppendingString:@".hws"]];
    }
    
}

#pragma mark -
#pragma mark Memory Management
-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) viewDidUnload {
    self.tableView = nil;
    self.listOfSavegames = nil;
    [super viewDidUnload];
}

-(void) dealloc {
    [tableView release];
    [listOfSavegames release];
    [super dealloc];
}

@end
