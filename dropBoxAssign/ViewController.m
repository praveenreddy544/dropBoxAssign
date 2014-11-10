//
//  ViewController.m
//  dropBoxAssign
//
//  Created by Praveen Poreddy on 11/7/14.
//  Copyright (c) 2014 CM. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
  self.restClient.delegate = self;
  dropBoxDataURLS=[[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)alertbutton:(id)sender {
  
  [self didPressLink];
  // Write a file to the local documents directory
  NSString *text = @"Demo drop-box API";
  NSString *filename = @"working-draft.txt";
  NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
  NSString *localPath = [localDir stringByAppendingPathComponent:filename];
  [text writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
  
  // Upload file to Dropbox
  NSString *destDir = @"/";
  [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:localPath];
  [self.restClient loadMetadata:@"/"];
  [self.tableView reloadData];
  //[self.restClient loadFile:dropboxPath intoPath:localPath];
  
}

- (IBAction)didPressLink {
  if (![[DBSession sharedSession] isLinked]) {
    [[DBSession sharedSession] linkFromController:self];
  }
}

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
  NSLog(@"File uploaded successfully to path: %@", metadata.path);
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
  NSLog(@"File upload failed with error: %@", error);
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
  if (metadata.isDirectory) {
    NSLog(@"Folder '%@' contains:", metadata.path);
    for (DBMetadata *file in metadata.contents) {
      NSLog(@"	%@", file.filename);
      [dropBoxDataURLS addObject:file.filename];
    }
  }
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
  NSLog(@"Error loading metadata: %@", error);
}

- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)localPath
       contentType:(NSString *)contentType metadata:(DBMetadata *)metadata {
  NSLog(@"File loaded into path: %@", localPath);
}

- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error {
  NSLog(@"There was an error loading the file: %@", error);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [dropBoxDataURLS count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *staticIdentif=@"dropBoxURL";
  UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:staticIdentif];
  if(cell==nil)
  {
    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:staticIdentif];
  }
  cell.textLabel.text=[dropBoxDataURLS objectAtIndex:indexPath.row];
  return cell;
}
@end
