//
//  DownloadsViewController.m
//  Browser
//
//  Created by Fauxly on 14.06.2026.
//  Copyright © 2026 High Caffeine Content. All rights reserved.
//
#import "DownloadsViewController.h"

@interface DownloadsViewController ()

@property (nonatomic, strong) NSArray<NSString *> *files;

@end

@implementation DownloadsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Downloads";

    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc]
     initWithTitle:@"Close"
     style:UIBarButtonItemStylePlain
     target:self
     action:@selector(close)];

    NSString *downloadsPath = @"/var/mobile/Documents";

    self.files =
    [[NSFileManager defaultManager]
     contentsOfDirectoryAtPath:downloadsPath
     error:nil];

    [self.tableView reloadData];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID = @"DownloadCell";

    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellID];

    if (!cell)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:CellID];
    }

    NSString *fileName = self.files[indexPath.row];
    
    NSString *fullPath =
    [@"/var/mobile/Documents"
     stringByAppendingPathComponent:fileName];

    NSDictionary *attributes =
    [[NSFileManager defaultManager]
     attributesOfItemAtPath:fullPath
     error:nil];

    unsigned long long fileSize =
    [attributes fileSize];

    NSString *sizeString;

    if (fileSize > 1024 * 1024 * 1024)
    {
        sizeString =
        [NSString stringWithFormat:@"%.2f GB",
         (double)fileSize / (1024.0 * 1024.0 * 1024.0)];
    }
    else if (fileSize > 1024 * 1024)
    {
        sizeString =
        [NSString stringWithFormat:@"%.2f MB",
         (double)fileSize / (1024.0 * 1024.0)];
    }
    else
    {
        sizeString =
        [NSString stringWithFormat:@"%.0f KB",
         (double)fileSize / 1024.0];
    }

    cell.textLabel.text = fileName;
    cell.detailTextLabel.text = sizeString;

    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *fileName = self.files[indexPath.row];
    NSString *extension = fileName.pathExtension.lowercaseString;
    
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"File Actions"
                                        message:fileName
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    if ([extension isEqualToString:@"deb"])
    {
        [alert addAction:
         [UIAlertAction actionWithTitle:@"Install Package"
                                  style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action)
         {
             UIAlertController *info =
             [UIAlertController alertControllerWithTitle:@"Install Package"
                                                 message:@"Coming Soon"
                                          preferredStyle:UIAlertControllerStyleAlert];

             [info addAction:
              [UIAlertAction actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                     handler:nil]];

             [self presentViewController:info
                                animated:YES
                              completion:nil];
         }]];
    }
    
    if ([@[@"mp4", @"mkv", @"avi", @"mov"] containsObject:extension])
    {
        [alert addAction:
         [UIAlertAction actionWithTitle:@"Play Video"
                                  style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action)
         {
             UIAlertController *info =
             [UIAlertController alertControllerWithTitle:@"Video Player"
                                                 message:@"Coming Soon"
                                          preferredStyle:UIAlertControllerStyleAlert];

             [info addAction:
              [UIAlertAction actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                     handler:nil]];

             [self presentViewController:info
                                animated:YES
                              completion:nil];
         }]];
    }
    
    [alert addAction:
     [UIAlertAction actionWithTitle:@"Delete File"
                              style:UIAlertActionStyleDestructive
                            handler:^(UIAlertAction *action)
     {
         NSString *fullPath =
         [@"/var/mobile/Documents"
          stringByAppendingPathComponent:fileName];

         [[NSFileManager defaultManager]
          removeItemAtPath:fullPath
          error:nil];

         NSMutableArray *updatedFiles =
         [self.files mutableCopy];

         [updatedFiles removeObjectAtIndex:indexPath.row];

         self.files = updatedFiles;

         [tableView reloadData];
     }]];

    [alert addAction:
     [UIAlertAction actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                            handler:nil]];

    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

@end
