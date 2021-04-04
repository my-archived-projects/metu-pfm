//
//  MainViewController.m
//  PFM
//
//  Created by Metehan Karabiber on 3/1/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#define ACC_MENU @[@"Hesap Yarat",@"Hesap Adı Değiştir",@"Hesap Kapat"]
#define TX_MENU @[@"İşlem Girişi",@"İşlem Sorgula",@"İşlem İptali", @"İşlem Transferi"]
#define REP_MENU @[@"Gelir Tablosu",@"Aylık Rapor",@"Hesap Ekstresi"]

#import "MainViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "BalanceSheetTablesDataSource.h"
#import "AccountCreateVC.h"
#import "AccountRenameVC.h"
#import "AccountCloseVC.h"
#import "TransactionVC.h"
#import "TransactionQueryVC.h"
#import "TransactionCancelVC.h"
#import "TransactionImportVC.h"
#import "IncomeTableVC.h"
#import "MonthlyReportVC.h"
#import "AccountStatementVC.h"
#import "AccountUtils.h"
#import "TxUtils.h"
#import "Account.h"

@interface MainViewController () <UIDocumentMenuDelegate, UIDocumentPickerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *activesTableView, *passivesTableView;
@property (nonatomic, weak) IBOutlet UILabel *noAccountLbl;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *txMenuBtn;

@property (nonatomic) UIPopoverController *accountPopover, *txPopover, *reportsPopover;
@property (nonatomic) NSArray *selectedArray;
@property (nonatomic) BalanceSheetTablesDataSource *bstds;

- (IBAction) about:(id)sender;

- (IBAction) accountsMenu:(id)sender;
- (IBAction) txsMenu:(id)sender;
- (IBAction) reportsMenu:(id)sender;

@end

@implementation MainViewController

- (void) viewDidLoad {
    [super viewDidLoad];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTables) name:reloadNotification object:nil];

    self.bstds = [[BalanceSheetTablesDataSource alloc] initWithActiveTable:self.activesTableView
															  passiveTable:self.passivesTableView];
    self.activesTableView.delegate = self.bstds;
    self.activesTableView.dataSource = self.bstds;
    self.passivesTableView.delegate = self.bstds;
    self.passivesTableView.dataSource = self.bstds;

    self.activesTableView.backgroundView = nil;
    self.activesTableView.backgroundColor = nil;
    self.passivesTableView.backgroundView = nil;
    self.passivesTableView.backgroundColor = nil;

	[self reloadTables];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:YES];
	
	[self reloadTables];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) reloadTables {
	
	self.activesTableView.hidden = ([AccountUtils fetchAccounts].count == 0);
	self.passivesTableView.hidden = ([AccountUtils fetchAccounts].count == 0);
	self.noAccountLbl.hidden = ([AccountUtils fetchAccounts].count != 0);

	self.bstds.fixedAssets = [AccountUtils fetchAccountsWithPredicate:[NSPredicate predicateWithFormat:@"group = %@", @(AccountGroupFixedAsset)]];
	self.bstds.longLiabilities = [AccountUtils fetchAccountsWithPredicate:[NSPredicate predicateWithFormat:@"group = %@", @(AccountGroupLongTerm)]];
    self.bstds.capitals = [AccountUtils fetchAccountsWithPredicate:[NSPredicate predicateWithFormat:@"group = %@", @(AccountGroupCapital)]];
    
	NSMutableArray *cAssets = [[AccountUtils fetchAccountsWithPredicate:[NSPredicate predicateWithFormat:@"group = %@", @(AccountGroupCurrentAsset)]] mutableCopy];
	NSMutableArray *sLiblts = [[AccountUtils fetchAccountsWithPredicate:[NSPredicate predicateWithFormat:@"group = %@", @(AccountGroupShortTerm)]] mutableCopy];

	NSArray *duals = [AccountUtils fetchAccountsWithPredicate:[NSPredicate predicateWithFormat:@"subtype = %@", @(AccountSubtypeDual)]];
	
	for (Account *account in duals) {
		if (account.balance.doubleValue >= 0) {
			[cAssets addObject:account];
		}
		else {
			[sLiblts addObject:account];
		}
	}

	self.bstds.curAssets = cAssets;
	self.bstds.shortLiabilities = sLiblts;

	[self.activesTableView reloadData];
	[self.passivesTableView reloadData];
}

- (IBAction) about:(id)sender {
	[Utils showMessage:@"SM 504 Team A\nCopyright © 2015" target:nil];
}
- (IBAction) accountsMenu:(id)sender {
	self.selectedArray = ACC_MENU;

	if (self.txPopover && self.txPopover.popoverVisible) {
		[self.txPopover dismissPopoverAnimated:YES];
		self.txPopover = nil;
	}
	if (self.reportsPopover && self.reportsPopover.popoverVisible) {
		[self.reportsPopover dismissPopoverAnimated:YES];
		self.reportsPopover = nil;
	}
	
	if (self.accountPopover && self.accountPopover.popoverVisible) {
		[self.accountPopover dismissPopoverAnimated:YES];
		self.accountPopover = nil;
	}
	else {
		if (self.accountPopover == nil) {
			UITableViewController *popoverTable = [[UITableViewController alloc] init];
			popoverTable.tableView.dataSource = self;
			popoverTable.tableView.delegate = self;
			popoverTable.preferredContentSize = CGSizeMake(180, self.selectedArray.count * 44);

			self.accountPopover = [[UIPopoverController alloc] initWithContentViewController:popoverTable];
		}
	 
		[self.accountPopover presentPopoverFromBarButtonItem:sender
									permittedArrowDirections:UIPopoverArrowDirectionUp
													animated:YES];
		self.accountPopover.passthroughViews = nil;
	}
}
- (IBAction) txsMenu:(id)sender {
	self.selectedArray = TX_MENU;
	
	if (self.accountPopover && self.accountPopover.popoverVisible) {
		[self.accountPopover dismissPopoverAnimated:YES];
		self.accountPopover = nil;
	}
	if (self.reportsPopover && self.reportsPopover.popoverVisible) {
		[self.reportsPopover dismissPopoverAnimated:YES];
		self.reportsPopover = nil;
	}
	
	if (self.txPopover && self.txPopover.popoverVisible) {
		[self.txPopover dismissPopoverAnimated:YES];
		self.txPopover = nil;
	}
	else {
		if (self.txPopover == nil) {
			UITableViewController *popoverTable = [[UITableViewController alloc] init];
			popoverTable.tableView.dataSource = self;
			popoverTable.tableView.delegate = self;
			popoverTable.preferredContentSize = CGSizeMake(180, self.selectedArray.count * 44);

			self.txPopover = [[UIPopoverController alloc] initWithContentViewController:popoverTable];
		}
	 
		[self.txPopover presentPopoverFromBarButtonItem:sender
							   permittedArrowDirections:UIPopoverArrowDirectionUp
											   animated:YES];
		self.txPopover.passthroughViews = nil;
	}
}
- (IBAction) reportsMenu:(id)sender {
	self.selectedArray = REP_MENU;

	if (self.accountPopover && self.accountPopover.popoverVisible) {
		[self.accountPopover dismissPopoverAnimated:YES];
		self.accountPopover = nil;
	}
	if (self.txPopover && self.txPopover.popoverVisible) {
		[self.txPopover dismissPopoverAnimated:YES];
		self.txPopover = nil;
	}

	if (self.reportsPopover && self.reportsPopover.popoverVisible) {
		[self.reportsPopover dismissPopoverAnimated:YES];
		self.reportsPopover = nil;
	}
	else {
		if (self.reportsPopover == nil) {
			UITableViewController *popoverTable = [[UITableViewController alloc] init];
			popoverTable.tableView.dataSource = self;
			popoverTable.tableView.delegate = self;
			popoverTable.preferredContentSize = CGSizeMake(180, self.selectedArray.count * 44);
			
			self.reportsPopover = [[UIPopoverController alloc] initWithContentViewController:popoverTable];
		}
	 
		[self.reportsPopover presentPopoverFromBarButtonItem:sender
							   permittedArrowDirections:UIPopoverArrowDirectionUp
											   animated:YES];
		self.reportsPopover.passthroughViews = nil;
	}
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.selectedArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *identifier = @"MainPopoverCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}
	cell.textLabel.text = self.selectedArray[indexPath.row];
	
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UIViewController *vc;
	if ([self.selectedArray isEqualToArray:ACC_MENU]) {
		if (indexPath.row == 0) {
			vc = [[AccountCreateVC alloc] initWithNibName:@"AccountCreateVC" bundle:nil];
		}
		else {
			if ([AccountUtils fetchAccounts].count == 0) {
				[Utils showMessage:@"Önce hesap yaratmalısınız!" target:nil];
				[self.accountPopover dismissPopoverAnimated:YES];
				self.accountPopover = nil;
				return;
			}

			if (indexPath.row == 1) {
				vc = [[AccountRenameVC alloc] initWithNibName:@"AccountRenameVC" bundle:nil];
			}
			else if (indexPath.row == 2) {
				vc = [[AccountCloseVC alloc] initWithNibName:@"AccountCloseVC" bundle:nil];
			}
		}
		vc.modalPresentationStyle = UIModalPresentationFormSheet;
		[self.accountPopover dismissPopoverAnimated:YES];
		self.accountPopover = nil;
	}
	else if ([self.selectedArray isEqualToArray:TX_MENU]) {
        if ([AccountUtils fetchAccounts].count == 0) {
            [Utils showMessage:@"Önce hesap yaratmalısınız!" target:nil];
            [self.txPopover dismissPopoverAnimated:YES];
            self.txPopover = nil;
            return;
        }

		if (indexPath.row == 3) {
			[self.txPopover dismissPopoverAnimated:YES];
			self.txPopover = nil;

			NSArray *types = @[(NSString *)kUTTypePlainText, (NSString *)kUTTypeTabSeparatedText];
			UIDocumentMenuViewController *importMenu = [[UIDocumentMenuViewController alloc]
														initWithDocumentTypes:types
																	   inMode:UIDocumentPickerModeImport];
			importMenu.delegate = self;
            importMenu.modalPresentationStyle = UIModalPresentationPopover;
            importMenu.popoverPresentationController.barButtonItem = self.txMenuBtn;
            [importMenu.view setTranslatesAutoresizingMaskIntoConstraints:NO];

			[self presentViewController:importMenu animated:YES completion:nil];
			return;
		}

		if (indexPath.row == 0) {
			vc = [[TransactionVC alloc] initWithNibName:@"TransactionVC" bundle:nil];
            vc.modalPresentationStyle = UIModalPresentationPageSheet;
		}
		else {
			if ([TxUtils fetchTransactions].count == 0) {
				[Utils showMessage:@"Hiç işlem girişi yapmadınız!" target:nil];
				[self.txPopover dismissPopoverAnimated:YES];
				self.txPopover = nil;
				return;
			}
			
			if (indexPath.row == 1) {
				vc = [[TransactionQueryVC alloc] initWithNibName:@"TransactionQueryVC" bundle:nil];
			}
			else if (indexPath.row == 2) {
				vc = [[TransactionCancelVC alloc] initWithNibName:@"TransactionCancelVC" bundle:nil];
			}
            vc.modalPresentationStyle = UIModalPresentationFormSheet;
		}
		
		[self.txPopover dismissPopoverAnimated:YES];
		self.txPopover = nil;
	}
	else if ([self.selectedArray isEqualToArray:REP_MENU]) {
		if (indexPath.row == 0) {
            if ([AccountUtils fetchAccountsWithPredicate:[NSPredicate predicateWithFormat:@"subtype = %@", @(AccountSubtypeIncome)]].count == 0 ||
                [AccountUtils fetchAccountsWithPredicate:[NSPredicate predicateWithFormat:@"subtype = %@", @(AccountSubtypeExpense)]].count == 0) {
                [Utils showMessage:@"Önce gelir-gider hesapları yaratmalısınız!" target:nil];
                [self.reportsPopover dismissPopoverAnimated:YES];
                self.reportsPopover = nil;
                return;
            }
            
			vc = [[IncomeTableVC alloc] initWithNibName:@"IncomeTableVC" bundle:nil];
		}
		else if (indexPath.row == 1) {
            if ([AccountUtils fetchAccountsWithPredicate:[NSPredicate predicateWithFormat:@"subtype = %@", @(AccountSubtypeIncome)]].count == 0 ||
                [AccountUtils fetchAccountsWithPredicate:[NSPredicate predicateWithFormat:@"subtype = %@", @(AccountSubtypeExpense)]].count == 0) {
                [Utils showMessage:@"Önce gelir-gider hesapları yaratmalısınız!" target:nil];
                [self.reportsPopover dismissPopoverAnimated:YES];
                self.reportsPopover = nil;
                return;
            }

			vc = [[MonthlyReportVC alloc] initWithNibName:@"MonthlyReportVC" bundle:nil];
		}
		else if (indexPath.row == 2) {
            if ([AccountUtils fetchAccounts].count == 0) {
                [Utils showMessage:@"Önce hesap yaratmalısınız!" target:nil];
                [self.reportsPopover dismissPopoverAnimated:YES];
                self.reportsPopover = nil;
                return;
            }

			vc = [[AccountStatementVC alloc] initWithNibName:@"AccountStatementVC" bundle:nil];
		}

		vc.modalPresentationStyle = UIModalPresentationPageSheet;
		[self.reportsPopover dismissPopoverAnimated:YES];
		self.reportsPopover = nil;
	}
	
	[self presentViewController:vc animated:YES completion:NULL];
}

- (void) documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker {
    documentPicker.delegate = self;
	[self presentViewController:documentPicker animated:YES completion:nil];
}

- (void) documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {

    if ([url.absoluteString hasSuffix:@".txt"] == NO) {
        [Utils showMessage:@".txt uzantılı tab delimited bir dosya seçmelisiniz!" target:nil];
        return;
    }

    NSString *content = [[NSString alloc] initWithContentsOfFile:url.path
                                                        encoding:NSUTF8StringEncoding
                                                           error:NULL];
	content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"];
	content = [content stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
	
	NSArray *lines = [content componentsSeparatedByString:@"\n"];
	if (lines == 0) {
		[Utils showMessage:@"Dosya boş görünüyor. Lütfen kontrol edin!" target:nil];
		return;
	}

	NSMutableArray *array = [NSMutableArray arrayWithCapacity:lines.count-1];
	NSString *errorMessage = nil;

	for (int i = 1; i < lines.count; i++) {
		NSString *str = [lines[i] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
		// Tab delimited file
		NSArray *objects = [str componentsSeparatedByString:@"\t"];
		
		Tx *tx = [Tx new];
		tx.date = objects[0];
		tx.debitAmt = [objects[1] isEqualToString:@""] ? nil : objects[1];
		tx.creditAmt = [objects[2] isEqualToString:@""] ? nil : objects[2];
		tx.desc = objects[3];
		[array addObject:tx];
		
		if ([Utils getDateFrom:tx.date] == nil) {
			errorMessage = @"Tarih formatlarında sorun var. Lütfen tarihlerin \"gg.aa.yyyy\" formatında olduğundan emin olun.";
			break;
		}
		if (!tx.debitAmt && !tx.creditAmt) {
			errorMessage = @"Tutar formatlarında sorun var yada tutarlarda boşluk var.";
			break;
		}
	}

	if (errorMessage) {
		[Utils showMessage:errorMessage target:nil];
		return;
	}

	if (array.count == 0) {
		[Utils showMessage:@"Dosyada işlem bulunamadı. Dosyanın doğru formatta olduğuna emin olun."
					target:nil];
		return;
	}

	UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
																   message:[NSString stringWithFormat:@"%ld işlem bulundu. Devam etmek istiyor musunuz?", array.count]
															preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:@"Hayır"
											  style:UIAlertActionStyleDefault
											handler:^(UIAlertAction * action) {}]];
	[alert addAction:[UIAlertAction actionWithTitle:@"Evet"
											  style:UIAlertActionStyleDefault
											handler:^(UIAlertAction * action) {
		TransactionImportVC *importVC = [[TransactionImportVC alloc] initWithNibName:@"TransactionImportVC" bundle:nil];
		importVC.transactions = array;
		importVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
		importVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

		[self presentViewController:importVC animated:YES completion:NULL];
											}]];
	[self presentViewController:alert animated:YES completion:nil];
}

@end
