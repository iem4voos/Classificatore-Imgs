//
//  IlControllerViewController.h
//  Classificatore-Imgs
//
//  Created by mic on 17/11/12.
//  Copyright (c) 2012 mic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IlControllerViewController : NSViewController{
    
@private
    //NSEnumerator *elenco;
    NSMutableArray * elencoFiles;
    int indiceFileCorrente;
    
    NSMutableArray * stringhePercorsi;
    NSURL *mainFolder;
    
    NSURL *currentFileURL;
    
    NSArray *etichetteBottoni;
    
}

@property (weak) IBOutlet NSTextField *errorLabel;

@property (weak) IBOutlet NSImageView *immagine;

// info panel
@property (weak) IBOutlet NSTextField *etichetta;
@property (weak) IBOutlet NSTextFieldCell *nomemefile;  // nomefile


@property (weak) IBOutlet NSButton *btnSceltaCartellaPrincipale;
- (IBAction)sceltaCartellaPrincipale:(id)sender;


@property (weak) IBOutlet NSButton *btnKeyA;
@property (weak) IBOutlet NSButton *btnKeyS;
@property (weak) IBOutlet NSButton *btnKeyD;
@property (weak) IBOutlet NSButton *btnKeyF;

- (IBAction)btnPressKeyA:(id)sender;

- (void)keyDown:(NSEvent *)event;



@end
