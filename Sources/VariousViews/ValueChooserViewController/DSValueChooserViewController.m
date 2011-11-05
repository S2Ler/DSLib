
#import "DSValueChooserViewController.h"

@interface DSValueChooserViewController()
@property (nonatomic, retain) NSIndexPath *selectedPath;
@end

@implementation DSValueChooserViewController
@synthesize selectedPath = _selectedPath;
@synthesize delegate = _delegate;
@synthesize userInfo = _userInfo;

- (id)initWithValues:(NSArray *)theValues
       selectedValue:(id)selectedValue
{
  self = [super init];
  if (self) {
    _values = [theValues retain];
    
    if (selectedValue) {
      for (int idx = 0; idx < [_values count]; idx++) {
        id value = [_values objectAtIndex:idx];
        if ([value compare:selectedValue] == NSOrderedSame) {
          [self setSelectedPath:[NSIndexPath indexPathForRow:idx
                                                   inSection:0]];
        }
      }
    }
  }
  return self;
}

- (void)dealloc
{
  Block_release(_filter);
  
  [_userInfo release];
  [_selectedPath release];
  [_values release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}
#pragma mark - Actions
- (void)cancelChoosingValues {
  [_delegate valueChooserViewControllerDidCancel:self];
}

- (void)doneChoosingValues {
  if ([self selectedPath]) {
    NSInteger selectedRow = [[self selectedPath] row];
    
    if (selectedRow < [_values count]) {
      id value = [_values objectAtIndex:selectedRow];      
      [_delegate valueChooserViewController:self
                            didEndWithValue:_filter(value)];
    } else {
      [_delegate valueChooserViewControllerDidCancel:self];      
    }
  } else {
    [_delegate valueChooserViewController:self
                          didEndWithValue:@""];
  }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [[self navigationItem] setHidesBackButton:YES];
  UIBarButtonItem *cancelButton 
  = [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
     target:self
     action:@selector(cancelChoosingValues)];
  [[self navigationItem] setLeftBarButtonItem:cancelButton];
  [cancelButton release];
  
  UIBarButtonItem *doneButton 
  = [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemDone
     target:self
     action:@selector(doneChoosingValues)];
  [[self navigationItem] setRightBarButtonItem:doneButton];
  [doneButton release];
  
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section 
{
  return [_values count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
  static NSString *const CELL_ID = @"Cell";
  
  UITableViewCell *cell 
  = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
  
  if (!cell) {
    cell = [[UITableViewCell alloc] 
            initWithStyle:UITableViewCellStyleValue1
            reuseIdentifier:CELL_ID];
    [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    [cell autorelease];
  }
  
  id value = [_values objectAtIndex:[indexPath row]];
  
  if ([value isKindOfClass:[NSString class]]) {
    [[cell textLabel] setText:value];
  } else {
    [[cell textLabel] setText:[value description]];
  }
  
  if ([indexPath isEqual:[self selectedPath]]) {
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
  } else {
    [cell setAccessoryType:UITableViewCellAccessoryNone];    
  }
  
  return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView 
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
  NSMutableSet *pathToReload = [NSMutableSet set];
  
  if ([self selectedPath]) {
    [pathToReload addObject:[self selectedPath]];
  }
  
  if ([indexPath isEqual:[self selectedPath]]) {
//    [self setSelectedPath:indexPath];
  } else {
    [self setSelectedPath:indexPath];
  }

  if ([self selectedPath]) {
    [pathToReload addObject:[self selectedPath]];
  }
  
  [tableView reloadRowsAtIndexPaths:[pathToReload allObjects]
                   withRowAnimation:UITableViewRowAnimationFade];
}

- (void)setValueFilterBlock:(value_filter_block_t)theFilter
{
  _filter = Block_copy(theFilter);
}
@end
