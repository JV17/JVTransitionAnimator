//
//  JVViewController.m
//  JVTransitionAnimtor
//
//  Created by Jorge Valbuena on 04/20/2015.
//  Copyright (c) 2014 Jorge Valbuena. All rights reserved.
//

#include <stdlib.h>
#import "JVViewController.h"
#import "JVSecondViewController.h"

#define ROW_HEIGHT 45
#define TABLEVIEW_ROWS_SECTION 9

@interface JVViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) JVTransitionAnimator *transitionAnimator;
@property (nonatomic, strong) JVSecondViewController *secondController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *selectedView;

@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *imagesBlack;
@property (nonatomic, strong) NSArray *sliders;
@property (nonatomic, strong) NSArray *moreLabels;

@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *delayLabel;
@property (nonatomic, strong) UILabel *dampingLabel;
@property (nonatomic, strong) UILabel *velocityLabel;

@end


@implementation JVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // gradient background color
    [JVAppHelper setGradientBackgroundInView:self.view withFirstHexColor:@"FF5E3A" andSecondHexColor:@"FF2A68"];
    
    self.labels = @[@"Push Off Animation",
                    @"Slide In/Out Animation",
                    @"Slide Up/Down Animation",
                    @"Zoom In Animation",
                    @"Zoom Out Animation"];
    
    self.images = @[[UIImage imageNamed:@"export"],
                    [UIImage imageNamed:@"import"],
                    [UIImage imageNamed:@"updown"],
                    [UIImage imageNamed:@"expand"],
                    [UIImage imageNamed:@"collapse"]];
    
    self.imagesBlack = @[[UIImage imageNamed:@"export-black"],
                         [UIImage imageNamed:@"import-black"],
                         [UIImage imageNamed:@"updown-black"],
                         [UIImage imageNamed:@"expand-black"],
                         [UIImage imageNamed:@"collapse-black"]];
    
    self.sliders = @[[self slidersWithFrame:CGRectMake(140, 0, CGRectGetWidth(self.view.frame)-170, 45) andSelector:@selector(updateDuration:) andMaxValue:5.0],
                     [self slidersWithFrame:CGRectMake(140, 0, CGRectGetWidth(self.view.frame)-170, 45) andSelector:@selector(updateDelay:) andMaxValue:5.0],
                     [self slidersWithFrame:CGRectMake(140, 0, CGRectGetWidth(self.view.frame)-170, 45) andSelector:@selector(updateDamping:) andMaxValue:1.0],
                     [self slidersWithFrame:CGRectMake(140, 0, CGRectGetWidth(self.view.frame)-170, 45) andSelector:@selector(updateVelocity:) andMaxValue:1.0]];
    
    self.moreLabels = @[[self labelsWithFrame:CGRectMake(10, 0, 70, 45) andText:@"Duration"],
                        [self labelsWithFrame:CGRectMake(10, 0, 70, 45) andText:@"Delay"],
                        [self labelsWithFrame:CGRectMake(10, 0, 75, 45) andText:@"Damping"],
                        [self labelsWithFrame:CGRectMake(10, 0, 70, 45) andText:@"Velocity"]];
    
    self.durationLabel = [self labelsWithFrame:CGRectMake(98, 0, 40, 45) andText:@"0.00"];
    self.delayLabel = [self labelsWithFrame:CGRectMake(98, 0, 40, 45) andText:@"0.00"];
    self.dampingLabel = [self labelsWithFrame:CGRectMake(98, 0, 40, 45) andText:@"0.00"];
    self.velocityLabel = [self labelsWithFrame:CGRectMake(98, 0, 40, 45) andText:@"0.00"];
    
    [self.view addSubview:self.label];
    [self.view addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Custom getters & setters

- (JVTransitionAnimator *)transitionAnimator
{
    if(!_transitionAnimator)
    {
        _transitionAnimator = [[JVTransitionAnimator alloc] init];
    }
    
    return _transitionAnimator;
}

- (JVSecondViewController *)secondController
{
    if(!_secondController)
    {
        _secondController = [[JVSecondViewController alloc] init];
    }
    
    return _secondController;
}

- (UILabel *)label
{
    if(!_label)
    {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 40)];
        _label.font = [UIFont fontWithName:@"HelveticaNeue" size:28];
        _label.textColor = [UIColor blackColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"JVTransitionAnimator";
        
        _label.layer.shadowColor = [UIColor blackColor].CGColor;
        _label.layer.shadowOpacity = 0.8;
        _label.layer.shadowRadius = 4;
        _label.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);

    }
    
    return _label;
}

- (UIView *)selectedView
{
    if(!_selectedView)
    {
        _selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ROW_HEIGHT)];
        _selectedView.backgroundColor = [[JVAppHelper colorWithHexString:@"DBDDDE"] colorWithAlphaComponent:0.9];
    }
    
    return _selectedView;
}

- (UISlider *)slidersWithFrame:(CGRect)frame andSelector:(SEL)targetAction andMaxValue:(CGFloat)max
{
    UISlider *slider = [[UISlider alloc] initWithFrame:frame];
    [slider addTarget:self action:targetAction forControlEvents:UIControlEventValueChanged];
    [slider setBackgroundColor:[UIColor clearColor]];
    slider.minimumValue = 0.00;
    slider.maximumValue = max;
    slider.continuous = YES;
    slider.value = 0.00;
    slider.minimumTrackTintColor = [JVAppHelper colorWithHexString:@"4A4A4A"];
    slider.maximumTrackTintColor = [JVAppHelper colorWithHexString:@"C7C7CC"];
    slider.thumbTintColor = [JVAppHelper colorWithHexString:@"F7F7F7"];
    
    return slider;
}

- (UILabel *)labelsWithFrame:(CGRect)frame andText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    label.textColor = [[JVAppHelper colorWithHexString:@"1F1F21"] colorWithAlphaComponent:0.9];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = text;
    
    return label;
}

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#pragma mark - TableView getter & setter

-(UITableView*)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.label.frame)+10, self.view.frame.size.width-20, CGRectGetHeight(self.view.frame)-CGRectGetMaxY(self.label.frame)+50) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
        {
            // remove leading spaces
            _tableView.layoutMargins = UIEdgeInsetsZero;
        }
        
        _tableView.bounces = YES;
        _tableView.scrollEnabled = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

#pragma mark - UITableView Delegate & Datasource

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
     if([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
     {
         self.tableView.layoutMargins = UIEdgeInsetsZero;
     }
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    // setups cell
    cell.layer.cornerRadius = 5.0;
    cell.layer.masksToBounds = YES;
    
    cell.selectedBackgroundView = self.selectedView;
        
    cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.textLabel.textColor = [[JVAppHelper colorWithHexString:@"F7F7F7"] colorWithAlphaComponent:0.9];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.highlightedTextColor = [JVAppHelper colorWithHexString:@"1F1F21"];
    
    if(indexPath.section == 0)
    {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
        cell.imageView.image = self.images[0];
        cell.textLabel.text = self.labels[0];
    }
    else if(indexPath.section == 1)
    {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
        cell.imageView.image = self.images[1];
        cell.textLabel.text = self.labels[1];
    }
    else if(indexPath.section == 2)
    {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
        cell.imageView.image = self.images[2];
        cell.textLabel.text = self.labels[2];
    }
    else if(indexPath.section == 3)
    {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
        cell.imageView.image = self.images[3];
        cell.textLabel.text = self.labels[3];
    }
    else if(indexPath.section == 4)
    {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
        cell.imageView.image = self.images[4];
        cell.textLabel.text = self.labels[4];
    }
    else if(indexPath.section == 5)
    {
        cell.selectedBackgroundView = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:self.moreLabels[0]];
        [cell.contentView addSubview:self.durationLabel];
        [cell.contentView addSubview:self.sliders[0]];
    }
    else if(indexPath.section == 6)
    {
        cell.selectedBackgroundView = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:self.moreLabels[1]];
        [cell.contentView addSubview:self.delayLabel];
        [cell.contentView addSubview:self.sliders[1]];
    }
    else if(indexPath.section == 7)
    {
        cell.selectedBackgroundView = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:self.moreLabels[2]];
        [cell.contentView addSubview:self.dampingLabel];
        [cell.contentView addSubview:self.sliders[2]];
    }
    else if(indexPath.section == 8)
    {
        cell.selectedBackgroundView = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:self.moreLabels[3]];
        [cell.contentView addSubview:self.velocityLabel];
        [cell.contentView addSubview:self.sliders[3]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if(indexPath.section == 0)
    {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next-black"]];
        cell.imageView.image = self.imagesBlack[0];
    }
    else if(indexPath.section == 1)
    {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next-black"]];
        cell.imageView.image = self.imagesBlack[1];
    }
    else if(indexPath.section == 2)
    {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next-black"]];
        cell.imageView.image = self.imagesBlack[2];
    }
    else if(indexPath.section == 3)
    {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next-black"]];
        cell.imageView.image = self.imagesBlack[3];
    }
    else if(indexPath.section == 4)
    {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next-black"]];
        cell.imageView.image = self.imagesBlack[4];
    }

}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(indexPath.section == 0)
    {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
        cell.imageView.image = self.images[0];
    }
    else if(indexPath.section == 1)
    {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
        cell.imageView.image = self.images[1];
    }
    else if(indexPath.section == 2)
    {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
        cell.imageView.image = self.images[2];
    }
    else if(indexPath.section == 3)
    {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
        cell.imageView.image = self.images[3];
    }
    else if(indexPath.section == 4)
    {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
        cell.imageView.image = self.images[4];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0)
    {
        self.secondController.transitioningDelegate = self.transitionAnimator;
        self.transitionAnimator.pushOffScreenAnimation = YES;
        self.transitionAnimator.slideUpDownAnimation = NO;
        self.transitionAnimator.slideInOutAnimation = NO;
        self.transitionAnimator.zoomInAnimation = NO;
        self.transitionAnimator.zoomOutAnimation = NO;
        [self presentViewController:self.secondController animated:YES completion:nil];
    }
    else if(indexPath.section == 1)
    {
        self.secondController.transitioningDelegate = self.transitionAnimator;
        self.transitionAnimator.slideInOutAnimation = YES;
        self.transitionAnimator.slideUpDownAnimation = NO;
        self.transitionAnimator.pushOffScreenAnimation = NO;
        self.transitionAnimator.zoomInAnimation = NO;
        self.transitionAnimator.zoomOutAnimation = NO;
        [self presentViewController:self.secondController animated:YES completion:nil];
    }
    else if(indexPath.section == 2)
    {
        self.secondController.transitioningDelegate = self.transitionAnimator;
        self.transitionAnimator.slideUpDownAnimation = YES;
        self.transitionAnimator.slideInOutAnimation = NO;
        self.transitionAnimator.pushOffScreenAnimation = NO;
        self.transitionAnimator.zoomInAnimation = NO;
        self.transitionAnimator.zoomOutAnimation = NO;
        [self presentViewController:self.secondController animated:YES completion:nil];
    }
    else if(indexPath.section == 3)
    {
        self.secondController.transitioningDelegate = self.transitionAnimator;
        self.transitionAnimator.slideInOutAnimation = NO;
        self.transitionAnimator.slideUpDownAnimation = NO;
        self.transitionAnimator.pushOffScreenAnimation = NO;
        self.transitionAnimator.zoomInAnimation = YES;
        self.transitionAnimator.zoomOutAnimation = NO;
        [self presentViewController:self.secondController animated:YES completion:nil];
    }
    else if(indexPath.section == 4)
    {
        self.secondController.transitioningDelegate = self.transitionAnimator;
        self.transitionAnimator.slideInOutAnimation = NO;
        self.transitionAnimator.slideUpDownAnimation = NO;
        self.transitionAnimator.pushOffScreenAnimation = NO;
        self.transitionAnimator.zoomInAnimation = NO;
        self.transitionAnimator.zoomOutAnimation = YES;
        [self presentViewController:self.secondController animated:YES completion:nil];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return TABLEVIEW_ROWS_SECTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return the number of sections in the tableview
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // return the height of row
    return ROW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}


#pragma mark - Slider helper functions

- (void)updateDuration:(UISlider *)slider
{
    if(slider.value > 0.0)
    {
        self.durationLabel.text = [NSString stringWithFormat:@"%.2f", slider.value];
        self.transitionAnimator.duration = slider.value;
    }
}

- (void)updateDelay:(UISlider *)slider
{
    if(slider.value >= 0.0)
    {
        self.delayLabel.text = [NSString stringWithFormat:@"%.2f", slider.value];
        self.transitionAnimator.delay = slider.value;
    }
}

- (void)updateDamping:(UISlider *)slider
{
    if(slider.value >= 0.0)
    {
        self.dampingLabel.text = [NSString stringWithFormat:@"%.2f", slider.value];
        self.transitionAnimator.damping = slider.value;
    }
}

- (void)updateVelocity:(UISlider *)slider
{
    if(slider.value >= 0.0)
    {
        self.velocityLabel.text = [NSString stringWithFormat:@"%.2f", slider.value];
        self.transitionAnimator.velocity = slider.value;
    }
}


@end