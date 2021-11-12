//
//  ViewController.m
//  MTrack
//
//  Created by Mac on 2021/10/27.
//

#import "ViewController.h"
#import "MMetaInfo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"一起去看风和日丽" ofType:@"mp3"];
    MMetaInfo *metaInfo = [[MMetaInfo alloc] init];
    NSDictionary *info = [metaInfo metaInfoWithURL:[NSURL URLWithString:@"http://downsc.chinaz.net/Files/DownLoad/sound1/201906/11582.mp3"]];
    NSLog(@"%@",info);
}


@end
