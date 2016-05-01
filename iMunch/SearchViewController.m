//
//  SearchViewController.m
//  iMunch
//
//  Created by Ananth Venkateswaran on 4/29/16.
//  Copyright © 2016 Ananth Venkateswaran. All rights reserved.
//

#import "SearchViewController.h"
#import "YelpAPIModel.h"
#import "SearchTableViewController.h"

@interface SearchViewController () <UITextFieldDelegate>
// private properties
@property (weak, nonatomic) IBOutlet UITextField *firstTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITextField *secondTextField;
@property (strong, nonatomic) YelpAPIModel *model;
@property (strong, nonatomic) NSMutableArray *searchResults;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _firstTextField.delegate = self;
    _secondTextField.delegate = self;
    [self checkTextFields];
    
    self.model = [YelpAPIModel sharedModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    // Set text to nothing
    textField.text = nil;
    
    return YES;
}
- (IBAction)goToSearchTable:(id)sender {
    _searchResults = [self.model searchResults:self.firstTextField.text location:self.secondTextField.text];
    [self performSegueWithIdentifier:@"searchSegue" sender:self];
}

- (BOOL) textField: (UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(nonnull NSString *)string {
    [self checkTextFields];
    return YES;
}
- (void) checkTextFields {
    if ([self.firstTextField.text length] > 0 && [self.secondTextField.text length] > 0) {
        self.searchButton.enabled = YES;
    } else {
        self.searchButton.enabled = NO;
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier  isEqual: @"searchSegue"]) {
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        SearchTableViewController *searchController = (SearchTableViewController*)[navController topViewController];
        searchController.results = [self searchResults];
    }
}


@end
