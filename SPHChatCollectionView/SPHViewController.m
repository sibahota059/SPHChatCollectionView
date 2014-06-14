//
//  SPHViewController.m
//  SPHChatCollectionView
//
//  Created by Siba Prasad Hota on 14/06/14.
//  Copyright (c) 2014 Wemakeappz. All rights reserved.
//

#import "SPHViewController.h"
#import "SPHCollectionViewcell.h"
#import "SPH_PARAM_List.h"

#import "SPHTextBubbleView.h"
#import "SPHImageBubbleView.h"


static NSString *kSTextByme=@"textByme";
static NSString *kSTextByOther=@"textbyother";
static NSString *kSImagebyme=@"ImageByme";
static NSString *kSImagebyOther=@"ImageByother";


static NSString *kStypeImage=@"Image";
static NSString *kStypeText=@"Text";


static NSString *kSending=@"Sending";
static NSString *kSent=@"Sent";
static NSString *kFailed=@"Failed";

static NSString *CellIdentifier = @"cellIdentifier";


#define TWO_THIRDS_OF_PORTRAIT_WIDTH (UIScreen.mainScreen.bounds.size.width * 0.6666667f)
#define MARGIN 10.0f
#define IMAGE_SIZE CGSizeMake(100,100)
#define MAX_BUBBLE_WIDTH  200.0

#define GRAY_TEXT_BUBBLE_COLOR [UIColor colorWithRed:0.866667 green:0.866667 blue:0.866667 alpha:1]
#define LIGHT_GRAY_TEXT_BUBBLE_COLOR [UIColor whiteColor]
#define GREEN_TEXT_BUBBLE_COLOR [UIColor colorWithRed:0.439216 green:0.854902 blue:0.223529 alpha:1]
#define LIGHT_GREEN_TEXT_BUBBLE_COLOR [UIColor colorWithHue:130.0f / 360.0f saturation:0.68f brightness:0.80f alpha:1.0f]
#define BLUE_TEXT_HIGHLIGHT_COLOR [UIColor colorWithRed:0.270588 green:0.545098 blue:1.000000 alpha:1]


@interface SPHViewController ()

@end

@implementation SPHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    sphBubbledata =[[NSMutableArray alloc]init];
    
    UINib *cellNib = [UINib nibWithNibName:@"View" bundle:nil];
    [self.sphChatTable registerNib:cellNib forCellWithReuseIdentifier:CellIdentifier];
    
    [self SetupDummyMessages];
    
    isfromMe=NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.sphChatTable addGestureRecognizer:tap];
     self.sphChatTable.backgroundColor =[UIColor clearColor];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.messageField.leftView = paddingView;
    self.messageField.leftViewMode = UITextFieldViewModeAlways;
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}


-(NSString *) genRandStringLength: (int) len {
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

-(void)SetupDummyMessages
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    //  msg_ID  Any Random ID
    
    //  mediaPath  : Your Message  or  Path of the Image
   
    [self adddMediaBubbledata:kSTextByme mediaPath:@"Hi, check this new control!" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    //[self performSelector:@selector(messageSent:) withObject:@"0" afterDelay:1];

    [self adddMediaBubbledata:kSTextByOther mediaPath:@"Hello! How are you?" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kSTextByme mediaPath:@"I'm doing Great!" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kSImagebyme mediaPath:@"ImageUrl" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kSImagebyOther mediaPath:@"Yeah its cool!" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kSTextByme mediaPath:@"Supports Image too." mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kSTextByOther mediaPath:@"Yup. I like the tail part of it." mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kSImagebyme mediaPath:@"ImageUrl" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSending msg_ID:@"ABFCXYZ"];
    
    [self adddMediaBubbledata:kSImagebyOther mediaPath:@"Hi, check this new control!" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    [self adddMediaBubbledata:kSTextByme mediaPath:@"lets meet some time for dinner! hope you will like it." mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    
  
    [self.sphChatTable reloadData];
}

-(void)messageSent:(NSString*)rownum
{
    int rowID=[rownum intValue];
    
    SPH_PARAM_List *feed_data=[[SPH_PARAM_List alloc]init];
    feed_data=[sphBubbledata objectAtIndex:rowID];
    
    [sphBubbledata  removeObjectAtIndex:rowID];
    feed_data.chat_send_status=kSent;
    [sphBubbledata insertObject:feed_data atIndex:rowID];
   
   // [self.sphChatTable reloadData];
   
    NSArray *indexPaths = [NSArray arrayWithObjects:
                           [NSIndexPath indexPathForRow:rowID inSection:0],
                           // Add some more index paths if you want here
                           nil];
    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:NO];
    [self.sphChatTable reloadItemsAtIndexPaths:indexPaths];
    [UIView setAnimationsEnabled:animationsEnabled];

    
    
    
}



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (sphBubbledata.count>2) {
        [self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.0];
    }
    
    CGRect msgframes=self.msgInPutView.frame;
    //CGRect btnframes=self.sendChatBtn.frame;
    CGRect tableviewframe=self.sphChatTable.frame;
    msgframes.origin.y=self.view.frame.size.height-260;
    tableviewframe.size.height-=200;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.msgInPutView.frame=msgframes;
        self.sphChatTable.frame=tableviewframe;
    }];
    
   
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{ CGRect msgframes=self.msgInPutView.frame;
    //CGRect btnframes=self.sendChatBtn.frame;
    CGRect tableviewframe=self.sphChatTable.frame;
    
    msgframes.origin.y=self.view.frame.size.height-50;
    tableviewframe.size.height+=200;
    self.sphChatTable.frame=tableviewframe;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.msgInPutView.frame=msgframes;
    }];
    
    
    
}

-(void)scrollTableview
{
    
    NSInteger item = [self collectionView:self.sphChatTable numberOfItemsInSection:0] - 1;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
    [self.sphChatTable
     scrollToItemAtIndexPath:lastIndexPath
     atScrollPosition:UICollectionViewScrollPositionBottom
     animated:NO];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SPH_PARAM_List *feed_data=[[SPH_PARAM_List alloc]init];
    feed_data=[sphBubbledata objectAtIndex:indexPath.row];
    
    if ([feed_data.chat_media_type isEqualToString:kSTextByme]||[feed_data.chat_media_type isEqualToString:kSTextByOther])
    {
        
        NSStringDrawingContext *ctx = [NSStringDrawingContext new];
        NSAttributedString *aString = [[NSAttributedString alloc] initWithString:feed_data.chat_message];
        UITextView *calculationView = [[UITextView alloc] init];
        [calculationView setAttributedText:aString];
        CGRect textRect = [calculationView.text boundingRectWithSize: CGSizeMake(TWO_THIRDS_OF_PORTRAIT_WIDTH, 10000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:calculationView.font} context:ctx];
        
        return CGSizeMake(306,textRect.size.height+40);
    }
    
    
    return CGSizeMake(306, 90);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return sphBubbledata.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     SPHCollectionViewcell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    SPH_PARAM_List *feed_data=[[SPH_PARAM_List alloc]init];
    feed_data=[sphBubbledata objectAtIndex:indexPath.row];
    
  //  NSLog(@"Chat Message =%@",feed_data.chat_message);
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        for (UIView *v in [cell.contentView subviews])
            [v removeFromSuperview];
        if ([self.sphChatTable.indexPathsForVisibleItems containsObject:indexPath])
        {
            if ([feed_data.chat_media_type isEqualToString:kSTextByme])
            {
                SPHTextBubbleView *textMessageBubble =
                [[SPHTextBubbleView alloc] initWithText:feed_data.chat_message
                                              withColor:GREEN_TEXT_BUBBLE_COLOR
                                     withHighlightColor:[UIColor whiteColor]
                                      withTailDirection:MessageBubbleViewButtonTailDirectionRight
                                               maxWidth:MAX_BUBBLE_WIDTH];
                
                [textMessageBubble sizeToFit];
                textMessageBubble.frame = CGRectMake(265-textMessageBubble.frame.size.width,0, textMessageBubble.frame.size.width, textMessageBubble.frame.size.height);
                [cell.contentView addSubview:textMessageBubble];
                
                
                UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-30, 55, 20)];
                timeLabel.text=feed_data.chat_date_time;
                timeLabel.font=[UIFont systemFontOfSize:9];
                timeLabel.textColor=[UIColor blackColor];
                [cell.contentView addSubview:timeLabel];
                
                
              
                if ([feed_data.chat_send_status isEqualToString:kSending])
                {
                    UIActivityIndicatorView *myIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    [myIndicator setFrame:CGRectMake(0,cell.frame.size.height-50,20, 20)];
                    [myIndicator startAnimating];
                    [cell.contentView addSubview:myIndicator];
                }
                else
                {
                    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0,cell.frame.size.height-50,16, 16)];
                    if ([feed_data.chat_send_status isEqualToString:kSent])
                        [imgView setImage:[UIImage imageNamed:@"sentSucess"]];
                    else
                        [imgView setImage:[UIImage imageNamed:@"sentFailed"]];//sentFailed
                    
                    [cell.contentView addSubview:imgView];
                }
                
                
                UIImageView *AvatarView=[[UIImageView alloc]initWithFrame:CGRectMake(265, cell.frame.size.height-50, 40, 40)];
                [AvatarView setImage:[UIImage imageNamed:@"person"]];
                
                AvatarView.layer.cornerRadius = 20.0;
                AvatarView.layer.masksToBounds = YES;
                AvatarView.layer.borderColor = [UIColor colorWithRed:0.224 green:0.255 blue:0.396 alpha:1.0].CGColor;
                AvatarView.layer.borderWidth = 2.0;
                [cell.contentView addSubview:AvatarView];
            }
            else
                if ([feed_data.chat_media_type isEqualToString:kSTextByOther])
                {
                    SPHTextBubbleView *textMessageBubble =
                    [[SPHTextBubbleView alloc] initWithText:feed_data.chat_message
                                                  withColor:LIGHT_GRAY_TEXT_BUBBLE_COLOR
                                         withHighlightColor:[UIColor blackColor]
                                          withTailDirection:MessageBubbleViewButtonTailDirectionLeft
                                                   maxWidth:MAX_BUBBLE_WIDTH];
                    
                    [textMessageBubble sizeToFit];
                    textMessageBubble.frame = CGRectMake(40,0, textMessageBubble.frame.size.width, textMessageBubble.frame.size.height);
                    [cell.contentView addSubview:textMessageBubble];
                    
                    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(260, cell.frame.size.height-30, 55, 20)];
                    timeLabel.text=feed_data.chat_date_time;
                    timeLabel.font=[UIFont systemFontOfSize:9];
                    timeLabel.textColor=[UIColor blackColor];
                    [cell.contentView addSubview:timeLabel];

                    
                    UIImageView *AvatarView=[[UIImageView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-50, 40, 40)];
                    AvatarView.layer.cornerRadius = 20.0;
                    AvatarView.layer.masksToBounds = YES;
                    AvatarView.layer.borderColor = [UIColor colorWithRed:0.224 green:0.255 blue:0.396 alpha:1.0].CGColor;
                    AvatarView.layer.borderWidth = 2.0;
                    [AvatarView setImage:[UIImage imageNamed:@"BlankUser.jpg"]];
                    [cell.contentView addSubview:AvatarView];
                    
                    
                }
                else
                    if ([feed_data.chat_media_type isEqualToString:kSImagebyme])
                    {
                        SPHImageBubbleView *flowerImageBubbleView =
                        [[SPHImageBubbleView alloc] initWithImage:[UIImage imageNamed:@"picture"] withTailDirection:MessageBubbleViewTailDirectionRight atSize:IMAGE_SIZE];
                        
                        [flowerImageBubbleView sizeToFit];
                        flowerImageBubbleView.frame = CGRectMake(170,0, 90, 90);
                        
                        [cell.contentView addSubview:flowerImageBubbleView];
                        
                        
                        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-30, 55, 20)];
                        timeLabel.text=feed_data.chat_date_time;
                        timeLabel.font=[UIFont systemFontOfSize:9];
                        timeLabel.textColor=[UIColor blackColor];
                        [cell.contentView addSubview:timeLabel];
                        
                        
                        
                        if ([feed_data.chat_send_status isEqualToString:kSending])
                        {
                            UIActivityIndicatorView *myIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                            [myIndicator setFrame:CGRectMake(0,cell.frame.size.height-50,20, 20)];
                            [myIndicator startAnimating];
                            [cell.contentView addSubview:myIndicator];
                        }
                        else
                        {
                            UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0,cell.frame.size.height-50,16, 16)];
                            if ([feed_data.chat_send_status isEqualToString:kSent])
                                [imgView setImage:[UIImage imageNamed:@"sentSucess"]];
                            else
                                [imgView setImage:[UIImage imageNamed:@"sentFailed"]];//sentFailed
                            
                            [cell.contentView addSubview:imgView];
                        }
                        

                        
                        UIImageView *AvatarView=[[UIImageView alloc]initWithFrame:CGRectMake(265, cell.frame.size.height-50, 40, 40)];
                        AvatarView.layer.cornerRadius = 20.0;
                        AvatarView.layer.masksToBounds = YES;
                        AvatarView.layer.borderColor = [UIColor colorWithRed:0.224 green:0.255 blue:0.396 alpha:1.0].CGColor;
                        AvatarView.layer.borderWidth = 2.0;
                        [AvatarView setImage:[UIImage imageNamed:@"person"]];
                        [cell.contentView addSubview:AvatarView];
                    }
                    else
                    {
                        SPHImageBubbleView *flowerImageBubbleView =
                        [[SPHImageBubbleView alloc] initWithImage:[UIImage imageNamed:@"app22"] withTailDirection:MessageBubbleViewTailDirectionLeft atSize:IMAGE_SIZE];
                        
                        [flowerImageBubbleView sizeToFit];
                        flowerImageBubbleView.frame = CGRectMake(40,0, 90, 90);
                        
                        [cell.contentView addSubview:flowerImageBubbleView];
                        
                        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(260, cell.frame.size.height-30, 55, 20)];
                        timeLabel.text=feed_data.chat_date_time;
                        timeLabel.font=[UIFont systemFontOfSize:9];
                        timeLabel.textColor=[UIColor blackColor];
                        [cell.contentView addSubview:timeLabel];

                        
                        UIImageView *AvatarView=[[UIImageView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-50, 40, 40)];
                        AvatarView.layer.cornerRadius = 20.0;
                        AvatarView.layer.masksToBounds = YES;
                        AvatarView.layer.borderColor = [UIColor colorWithRed:0.224 green:0.255 blue:0.396 alpha:1.0].CGColor;
                        AvatarView.layer.borderWidth = 2.0;
                        [AvatarView setImage:[UIImage imageNamed:@"BlankUser.jpg"]];
                        [cell.contentView addSubview:AvatarView];
                        
                    }
            

            
        }
    });
    
    
    
        return cell;
}





-(void)adddMediaBubbledata:(NSString*)mediaType  mediaPath:(NSString*)mediaPath mtime:(NSString*)messageTime thumb:(NSString*)thumbUrl  downloadstatus:(NSString*)downloadstatus sendingStatus:(NSString*)sendingStatus msg_ID:(NSString*)msgID
{
    
    SPH_PARAM_List *feed_data=[[SPH_PARAM_List alloc]init];
    feed_data.chat_message=mediaPath;
    feed_data.chat_date_time=messageTime;
    feed_data.chat_media_type=mediaType;
    feed_data.chat_send_status=sendingStatus;
    feed_data.chat_Thumburl=thumbUrl;
    feed_data.chat_downloadStatus=downloadstatus;
    feed_data.chat_messageID=msgID;
    [sphBubbledata addObject:feed_data];
}

/*
 for (int i = resultsSize; i < resultsSize + 1; i++)
 {
 [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:resultsSize inSection:0]];
 }
 */


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMessageNow:(id)sender
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    if ([self.messageField.text length]>0) {
        
        if (isfromMe)
        {
            NSString *rowNum=[NSString stringWithFormat:@"%d",sphBubbledata.count];
            [self adddMediaBubbledata:kSTextByme mediaPath:self.messageField.text mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSending msg_ID:[self genRandStringLength:7]];
            [self performSelector:@selector(messageSent:) withObject:rowNum afterDelay:1];
           
            isfromMe=NO;
        }
        else
        {
            [self adddMediaBubbledata:kSTextByOther mediaPath:self.messageField.text mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
            isfromMe=YES;
        }
        
        [self.sphChatTable reloadData];
        [self scrollTableview];
    }
}
@end
