//
//  TxLabels.h
//  PFM
//
//  Created by Metehan Karabiber on 26/03/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#define TYPES @[\
@"Gelir İşlemi",\
@"Harcama İşlemi",\
@"Varlık Alımı",\
@"Varlık Satışı",\
@"Borç Alma",\
@"Borç Ödeme",\
@"Borç Verme",\
@"Verilen Borcu Geri Alma",\
@"Manuel İşlem Girişi"]

#define DEBITLBLS @[\
@"Gelir Aktarılan Hesap",\
@"Harcama Hesabı",\
@"Alınan Varlık Hesabı",\
@"Satıştan Elde Edilen",\
@"Alınan Borcun Yattığı",\
@"Ödenen Borç",\
@"Borcun Kaydedildiği Hesap",\
@"Alınan Borcun Kaydedildiği",\
@"Borçlu Hesap"]

#define CRDITLBLS @[\
@"Gelir Hesabı",\
@"Ödeme Hesabı",\
@"Ödeme Yapılan Hesap",\
@"Satılan Varlık Hesabı",\
@"Borcun Kaydedildiği Hesap",\
@"Borcun Ödendiği Hesap",\
@"Borç Verilen Hesap",\
@"Geri Alınan Borç Hesabı",\
@"Alacaklı Hesap"]

#define HELPTXTS @[\
@"Gelir işlemleri, maaşınız, ikramiye, faiz geliri, hisse senedi geliri gibi varlıklarınızı artırıcı işlemlerdir.",\
@"Harcama işlemi yemek, benzin, faiz gideri gibi varlıklarınızı azaltıcı işlemlerdir. Ev, araba vs almak harcama değildir, varlık alımıdır",\
@"Varlık alımı, sizde daha önce olmayan bir varlığı satın almanızdır. Bu varlıklar tüketilebilir (yemek, benzin, alışveriş) varlık değil, ev, araba, beyaz eşya gibi varlıklardır.",\
@"Varlıklarınızda kayıtlı bir varlığı satış işlemi. Dikkat edilecek nokta, eğer varlığı kayıtlı değerinden fazlaya sattıysanız, fazlalık olan tutar gelir olarak kaydedilmelidir. Zarar ettiyseniz de zarar tutarını giderlere kaydetmelisiniz. Bunun için birden fazla satırlı işlem girişi gerekir.",\
@"Bir arkadaşınızdan borç alma ya da bankadan kredi çekme gibi işlemlerdir.",\
@"Borç aldığınız arkadaşınıza yada borçlu olduğunuz bankaya yapılan geri ödemelerdir.",\
@"Genellikle bir arkadaşınıza borç verme işlemi. Bu hesabı takip için hesap oluşturmuş olmanız gerekir. Örn: \"ARKADAŞLARDAN ALACAKLAR\" yada tek tek \"AHMET BEY HESABI\" gibi. Hem borçlu, hem alacaklı olabileceğiniz hesapları yaratırken DUAL seçeneğini seçin.",\
@"Verdiğiniz bir borcu geri alma işlemi.",\
@"1)\"Borçlu Hesap\" olarak seçtiğiniz hesap, eğer Gider hesabı, Varlık veya Dual karakterli bir hesapsa, hesabın bakiyesi artar, aksi takdirde azalır.\n2) \"Alacaklı Hesap\" olarak seçtiğiniz hesap, eğer Gelir hesabı veya Borç hesabı ise, hesabın bakiyesi artar, aksi takdirde azalır."]
