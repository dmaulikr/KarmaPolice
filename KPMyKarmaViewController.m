    //
//  KPMyKarmaViewController.m
//  KarmaPolice
//
//  Created by Gil Shulman on 3/25/14.
//  Copyright (c) 2014 Karma Police. All rights reserved.
//

#import "KPMyKarmaViewController.h"

@interface KPMyKarmaViewController ()

@end


@implementation KPMyKarmaViewController //Test

{
    NSMutableArray *questionsArray;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        //_QuestionTableView.contentSize = _QuestionTableView.bounds.size;
        //_QuestionTableView.scrollEnabled = YES;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [questionsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TableViewCell";
    
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSMutableDictionary *mutableDict = questionsArray[indexPath.row];
    
    cell.timeLabel.text = [questionsArray[indexPath.row] objectForKey:@"createdAt"];
    cell.questionLabel.text = [questionsArray[indexPath.row] objectForKey:@"questionText"];
    cell.resultsLabel.text = @"Oy";
    cell.peopleLabel.text = @"Oy X2";
    cell.privacySegments.selectedSegmentIndex = [questionsArray[indexPath.row] objectForKey:@"privacyLevel"];
    
    return cell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    questionsArray = [[NSMutableArray alloc] init];
    
    _QuestionTableView.delegate = self;
    _QuestionTableView.dataSource = self;
    
    // Do any additional setup after loading the view.
    // questionsArray = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    [self populateArray];

}

- (void) populateArray {
    PFQuery *query = [PFQuery queryWithClassName:@"TblQuestions"];
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"UserId" equalTo:user.objectId];
        // This needs error handling: Gil to add @try @Catch:
        NSArray *objects = [query findObjects];
    
        if (objects.count > 0) {
            // The find succeeded
            NSLog(@"Successfully retrieved %d questions", objects.count);
            int questionIndex;
            questionIndex = 0;
            while (objects.count > questionIndex){
                PFObject *object = objects[questionIndex];
                
                // Get the date from parse and format it:
                NSDate *createdAt = [object createdAt];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"EEE, MMM d, h:mm a"];
                NSString* strCreatedAt = [NSString stringWithFormat:@"Lasted Updated: %@", [dateFormat stringFromDate:createdAt]];
         
                NSArray *keys = [NSArray arrayWithObjects:@"questionText", @"CreatedAt", @"privacyLevel",@"percantageYes",@"totalNumberOfAnswers", nil];
                NSArray *arrObjects = [NSArray arrayWithObjects:[object objectForKey:@"Question"],strCreatedAt,[object objectForKey:@"allKP"],@"0",@"0", nil];
                NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:arrObjects forKeys:keys];
                
                NSMutableDictionary *mutableDict; //= [[NSMutableDictionary alloc]init];
                mutableDict = [dictionary mutableCopy];
                
                NSLog(@"NSMutableDictionary content:  %@", [mutableDict valueForKey:@"questionText"]);
                
                
                [questionsArray addObject:[mutableDict copy]];
                
                NSMutableDictionary *Testy = questionsArray[questionIndex];
                
                NSLog(@"Array content:  %@", [Testy valueForKey:@"questionText"]);
                questionIndex++;
            }
        }
   // }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
