//
//  IlControllerViewController.m
//  Classificatore-Imgs
//
//  Created by mic on 17/11/12.
//  Copyright (c) 2012 mic. All rights reserved.
//

// NSURL *bUrl = [aUrl URLByAppendingPathComponent:@"newString"];

#import "IlControllerViewController.h"

#define PREFS_ELENCO_CARTELLE @"elencoCartelle"
#define PREFS_MAIN_PATH @"cartellaPrincipale"

@interface IlControllerViewController ( )

@end

@implementation IlControllerViewController

@synthesize etichetta;
@synthesize immagine, nomemefile;

@synthesize btnKeyA, btnKeyS,btnKeyD,btnKeyF,btnSceltaCartellaPrincipale, errorLabel;

typedef enum tipiDiFile {IMMAGINE,ARCHIVIO,ALTRO} tipiDiFile_t;


// never called
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

#pragma mark -


- (void)awakeFromNib {

    etichetteBottoni = [NSArray arrayWithObjects:btnKeyA,btnKeyS,btnKeyD,btnKeyF, nil];
    
    NSLog(@"sono sveglio");
    
    [etichetta setSelectable:YES];
    [errorLabel setHidden:YES];
        
    [self loadSettings];
    
    if(mainFolder)
        [self loadFilesArray: mainFolder];
   
}

-(void)loadSettings{
    //NSLog(@"loadingSettings");
    
    NSUserDefaults  * prefs     = [NSUserDefaults standardUserDefaults];
    NSURL           * mFolder   = [prefs URLForKey: PREFS_MAIN_PATH];
    NSArray         * array     = [prefs stringArrayForKey:PREFS_ELENCO_CARTELLE];
    //NSMutableArray  * percs     = [NSMutableArray arrayWithArray:array];
    NSError         * err       = nil;
    
    [mFolder checkResourceIsReachableAndReturnError:&err];
    
    if (!mFolder) {
        ////NSLog(@"mFolder e null!!!");
    }
    
    if(mFolder && err == NULL){
        mainFolder = mFolder;
        [btnSceltaCartellaPrincipale setTitle:[mainFolder path]];
    }else {
        mainFolder = nil;
        [btnSceltaCartellaPrincipale setTitle:@"Select"];
    }
    
    if(array == NULL){
        //NSLog(@"array e vuoto!!!");
    }
    
   
    ////NSLog(@" ci sono %ld elementi", [array count]);

    // create a dymmy array to save in prefs
    if([array count] == 0){
        NSMutableArray *tmp = [NSMutableArray array];
        for(int i=0; i< [etichetteBottoni count]; i++){
            [tmp addObject:@":-)"];
        }
        array = [NSArray arrayWithArray:tmp];
    }
    
    stringhePercorsi = [NSMutableArray arrayWithArray:array];
    
    for( int i=0;array && i< [etichetteBottoni count]; i++ ){
        err=nil;
        
        NSURL *ur= [NSURL URLWithString:[array objectAtIndex:i]];
        
        //NSLog(@"[%d] %@ (%@)",i, ur,[array objectAtIndex:i]);
        [ur checkResourceIsReachableAndReturnError:&err];
    
        if(err == NULL && ur!=nil){
            ////NSLog(@"All fine %@", [ur path]);
            [elencoFiles setObject:ur atIndexedSubscript:i];
            [(NSButton *)[etichetteBottoni objectAtIndex:i] setTitle:[ur path]];
        }else {
            ////NSLog(@"array Errore loadSettings %@", err);
            [stringhePercorsi setObject:@":-)" atIndexedSubscript:i];
            [elencoFiles setObject:[NSNull null] atIndexedSubscript:i];
            [(NSButton *)[etichetteBottoni objectAtIndex:i] setTitle:@"Select"];
        }
    }
    
}

#pragma mark -

- (IBAction)sceltaCartellaPrincipale:(id)sender {
    
    
    NSURL * tmp=[self selectAFolderPath];
    
    if(tmp==nil) return;
    
    mainFolder = tmp;
    [[NSUserDefaults standardUserDefaults] setURL:mainFolder forKey:PREFS_MAIN_PATH];
    
    [btnSceltaCartellaPrincipale setTitle:[mainFolder path]];
    
   // NSUserDefaults  * prefs     = [NSUserDefaults standardUserDefaults];
   // NSURL           * mFolder   = [prefs URLForKey:PREFS_MAIN_PATH];
    
    //NSLog(@">> %@ salvato: %@",PREFS_ELENCO_CARTELLE, mFolder);
    
    [self loadFilesArray: mainFolder];
    
    //[finestraPrincipale  makeKeyWindow];
    
}


- (IBAction)btnPressKeyA:(id)sender {
   
    //NSLog(@"il numero e%ld",[sender tag]);
    // apri finestra e prendi il path
    
     NSURL *imageURL= [self selectAFolderPath];
    
    if (imageURL== nil) {
        //NSLog(@"Fallito");
        return;
    }
    
    //swiche assegna al vettore di stringhe
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults] ;    
    
    [stringhePercorsi setObject:[imageURL absoluteString] atIndexedSubscript:[sender tag]];

    [preferences setObject: [NSArray arrayWithArray:stringhePercorsi] forKey:PREFS_ELENCO_CARTELLE];
    [preferences synchronize];
    
    [(NSButton *)[etichetteBottoni objectAtIndex:[sender tag]] setTitle:[imageURL path]];
}


-(void) fullScreenToogle{
    
    NSDictionary *opts = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithBool:NO], NSFullScreenModeAllScreens, nil];

    NSView * aView = [[immagine window] contentView] ;
    
    if ([aView isInFullScreenMode] == NO)
    {
        //[self fadeOut];
        [aView enterFullScreenMode:[NSScreen mainScreen]
                       withOptions:opts];
        //[self fadeIn];
    }
    else
    {
        //[self fadeOut];
        [aView exitFullScreenModeWithOptions:opts];
        //[self fadeIn];
    } //end if
    
}

- (void)keyDown:(NSEvent *)event {
    ////NSLog(@"Hi there");
    
     [errorLabel setHidden:YES];
    
    int num= -1;
    
    NSString *characters = [event characters];
    if ([characters length]) {
        switch ([characters characterAtIndex:0]) {
           
            case 'w':
            case NSDownArrowFunctionKey:
            case NSRightArrowFunctionKey:
                //NSLog(@"Key Right");
                [self prossimo];
                break;
            case 'q':
            case NSUpArrowFunctionKey:
            case NSLeftArrowFunctionKey:
                //NSLog(@"Key Left");
                [self precedente];
                break;
            //-------- / Arrows ------------
            case 27:
                //NSLog(@"EsC");
                [self fullScreenToogle];
                break;
            //------------------------
            case 'A':
            case 'a':
                //NSLog(@"Key AAAA");
                num = 0;
                break;
            case 'S':
            case 's':
                //NSLog(@"Key SSSS");
                num = 1;
                break;
            case 'D':
            case 'd':
                //NSLog(@"Key DDD");
                num = 2;
                break;
            case 'F':
            case 'f':
                //NSLog(@"Key FFF");
                num = 3;
                break;
            //----------------
            case 'O':
            case 'o':
                //NSLog(@"Key FFF");
                [[NSWorkspace sharedWorkspace] selectFile:[currentFileURL path] inFileViewerRootedAtPath:nil];
                break;
                
                // [[NSWorkspace sharedWorkspace] selectFile:[imageURL path] inFileViewerRootedAtPath:nil];
        }
    }
    
    
    
    
    if (num >= 0){
     
        NSString * folder;
        
        if (!(folder=[stringhePercorsi objectAtIndex:num])) {
            //NSLog(@"Erroe");
            return;
        }

        NSURL *sorgente = currentFileURL;
        
       // NSURL * destinaz_tmp = [NSURL URLWithString: folder];
        
        
        NSURL * destina = [[NSURL URLWithString: folder] URLByAppendingPathComponent:[currentFileURL lastPathComponent]];
        
        //int dovesono= indiceFileCorrente;
        
        
        
        if([self sposta:sorgente :destina ]){
            [elencoFiles removeObjectAtIndex:indiceFileCorrente];
            indiceFileCorrente--;
            [self prossimo];
        }
        else{
            //NSLog(@"ERROREEEE");
            [etichetta setTextColor: [NSColor redColor]];
        }
        
    }
    
    
}

#pragma mark -

- (BOOL)fileManager:(NSFileManager *)fileManager shouldProceedAfterError:(NSError *)error movingItemAtURL:(NSURL *)srcURL toURL:(NSURL *)dstURL{
    NSLog(@"shouldProceedAfterError");
    if(error.code == 516){
        NSLog(@"Error 516 . destinazione esiste. sovrascrivo ");
        return YES;
    }
    
    return NO;
}

-(int) sposta: (NSURL*) da:  (NSURL*) a{
    
    [[NSFileManager defaultManager] setDelegate:self];
    
    NSError *error = nil;

    if (da == nil || a == nil) return 0;
    
     //NSLog(@"provo a copiare da %@ a %@", da, a);

    [[NSFileManager defaultManager] moveItemAtURL:da toURL:a error:&error];
    
    if(error){
        NSLog(@"ERRORE spostamento file!!!: %@", error);
         [errorLabel setHidden:FALSE];
        return 0;
    }
    
    
    return 1;
    
}


-(void ) prossimo_xbk{
    NSURL *aaa;
    
    unsigned long totCount;
    
    totCount = [elencoFiles count];
    if (totCount <= indiceFileCorrente) {
        return;
    }
    aaa      = [elencoFiles objectAtIndex:indiceFileCorrente];
    
    while ( (ALTRO == [self whatTypeOfFile:aaa]) && (indiceFileCorrente < totCount) ) {
        [elencoFiles removeObjectAtIndex:indiceFileCorrente];
        if([elencoFiles count]==0){
            return;
        }
        aaa      = [elencoFiles objectAtIndex:indiceFileCorrente];
        totCount = [elencoFiles count];
    }
    
    if(! aaa){
        //NSLog(@"Fine Cartella");
        [immagine setImage:nil];
        return;
    }

    [self carica:aaa];
}

- (void) prossimo{
    unsigned long totCount = [elencoFiles count];;
    
    indiceFileCorrente++;
    
    if (indiceFileCorrente >= totCount) {
        indiceFileCorrente = 0;
    }
    
    [self prossimo_xbk];
}

- (void)precedente{
    unsigned long totCount = [elencoFiles count];;
    
    indiceFileCorrente--;
    
    if (indiceFileCorrente < 0) {
        indiceFileCorrente = (int)totCount -1;
    }
    
    [self prossimo_xbk];
}


-(tipiDiFile_t) whatTypeOfFile: (NSURL *)aUrl{
    
    if(aUrl==nil) return 0;
    
    CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,(__bridge CFStringRef) [aUrl pathExtension], NULL);

    tipiDiFile_t tipo = ALTRO;
    
    if ( UTTypeConformsTo(fileUTI, kUTTypeImage)  ){
        tipo = IMMAGINE;
    }else if( UTTypeConformsTo(fileUTI, kUTTypeArchive) ){
        tipo = ARCHIVIO;
    }
    
    CFRelease(fileUTI);
    
    return tipo;
}

-(void) carica:(NSURL*)imageURL{
    
    //NSLog(@"loading pic percorso: %@",imageURL);
    NSImage * theImage;
    if([self whatTypeOfFile: imageURL] == ARCHIVIO){
        theImage = [NSImage imageNamed:@"WinZip_icon.png"];
       // [[NSWorkspace sharedWorkspace] selectFile:[imageURL path] inFileViewerRootedAtPath:nil];
    }
    else
         theImage = [[NSImage new] initByReferencingURL:imageURL];

    [immagine setImage:theImage];
    [[immagine window] makeKeyWindow];
    
    //currentFileName = [imageURL lastPathComponent];
    //currentFullPath = [imageURL absoluteString];
    currentFileURL = imageURL;
    
    [nomemefile setStringValue:[imageURL lastPathComponent]];
    [etichetta setStringValue:[imageURL absoluteString]];
    [etichetta setTextColor: [NSColor whiteColor]];
}


- ( NSURL * ) selectAFolderPath{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    [openDlg setAllowsMultipleSelection:FALSE];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setCanChooseFiles:FALSE];
    
    NSInteger openDialogResult;
    
    openDialogResult=[openDlg runModal];
    
    if(openDialogResult != NSOKButton){
        return nil;
    }else {
        NSArray* urls=  [openDlg URLs];
        NSURL * un_ur = [urls lastObject];
        //NSLog(@"%@",un_ur);
        return un_ur;
    }
}

- (void)loadFilesArray: (NSURL *)folderUrl
{
    
    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    
    // enumerator is RECURSIVE!!
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]
                                         enumeratorAtURL:folderUrl
                                         includingPropertiesForKeys:keys
                                         options:0
                                         errorHandler:^(NSURL *url, NSError *error) {
                                             // Handle the error.
                                             // Return YES if the enumeration should continue after the error.
                                             return YES;
                                         }];

    
    NSArray *array =[enumerator  allObjects];
    
    elencoFiles= [NSMutableArray arrayWithArray:array];
    indiceFileCorrente =0;
    
    [self prossimo];    
}


///---------------

@end

