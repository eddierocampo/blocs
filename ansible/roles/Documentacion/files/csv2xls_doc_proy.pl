#!/usr/local/bin/perl -w

use strict;
use Spreadsheet::WriteExcel;


if($#ARGV ne 1)
{
print "\n Usage: txt2xls \n Example: txt2xls \"|\" *.psv\n\n";
}

my $input = " ";
my $token;
my $file;
my $del;
my $wb;
my $sw_fs = 0;
my $sw_fs1 = 0;
my $sw_cpu = 0;
my $sw_memsw = 0;
my $cont = 0;
my $cont1 = 0;
my @files = @ARGV[1..$#ARGV];

foreach $file (@files){
open (TXTFILE, "$file") or die;
my $wb = Spreadsheet::WriteExcel->new("$file.xls");
my $excel = $wb->addworksheet();
###########
# Ajusto tamano de celdas
#
$excel->set_column(0, 3, 15);
$excel->set_column(4, 4, 18);
$excel->set_column(5, 5, 11);
$excel->set_column(6, 6, 34);
$excel->set_column(7, 7, 40);
$excel->set_column(8, 8, 48);
# Create a merge format
#
my $format = $wb->add_format(
                                    center_across   => 1,
                                    bold            => 1,
                                    size            => 9,
                                    pattern         => 1,
                                    border          => 6,
                                    color           => 'white',
                                    fg_color        => 'green',
                                    border_color    => 'yellow',
                                    align           => 'vcenter',
                                    );
my $fs = $wb->add_format(
                                    center_across   => 1,
                                    bold            => 1,
                                    size            => 9,
                                    pattern         => 1,
                                    border          => 6,
                                    color           => 'white',
                                    fg_color        => 'green',
                                    border_color    => 'yellow',
                                    align           => 'vcenter',
                                    );
my $fs1 = $wb->add_format(
                                    center_across   => 1,
                                    bold            => 1,
                                    size            => 9,
                                    pattern         => 1,
                                    border          => 6,
                                    color           => 'white',
                                    fg_color        => 'green',
                                    border_color    => 'yellow',
                                    align           => 'vcenter',
                                    );
my $cpu = $wb->add_format(
                                    center_across   => 1,
                                    bold            => 1,
                                    size            => 9,
                                    pattern         => 1,
                                    border          => 6,
                                    color           => 'white',
                                    fg_color        => 'green',
                                    border_color    => 'yellow',
                                    align           => 'vcenter',
                                    );
my $memsw = $wb->add_format(
                                    center_across   => 1,
                                    bold            => 1,
                                    size            => 9,
                                    pattern         => 1,
                                    border          => 6,
                                    color           => 'white',
                                    fg_color        => 'green',
                                    border_color    => 'yellow',
                                    align           => 'vcenter',
                                    );


#$excel->write($format);
my $row = 1;
my $col;

$format = $wb->add_format();
$format->set_bold();
$format->set_color('black');
$format->set_fg_color('light blue');
$format->set_align('center');
$format->set_border('2');
#
# Inicio lectura del archivo de texto
#
while (<TXTFILE>) {
      chomp;
      if ($ARGV[0] =~ /\|/)
         {
         $del="\\|";
         }
      else
         {
         $del = $ARGV[0];
         }
#
# Inicio lectura e impresion de columnas de una linea o registro leida
#
my @Fld = split(/$del/, $_);
$col = 1;
#########
#
#    Inicio validacion y colocacion de colores tipo tabla
#
#print "$_ \n";
$format = $wb->add_format();
$format->set_size(11);
$format->set_font('Calibri');
$format->set_color('black');
$format->set_fg_color('white');
$format->set_align('center');
$format->set_border('1');
if ( $_ =~ "FORMATO DE ENTREGA|DISKMAPPING" ) {
   $sw_fs=1;
   $fs = $wb->add_format();
   $fs->set_bold(1);
   $fs->set_size(22);
   $fs->set_font('Calibri');
   $fs->set_color('violet');
   $fs->set_align('center');
   }
if ( $_ =~ "no " ) {
   $sw_fs=9;
   $fs = $wb->add_format();
   $fs->set_bold();
   $fs->set_color('white');
   $fs->set_fg_color('red');
   $fs->set_align('center');
   $fs->set_border('1');
   }
if ( $_ =~ "si " ) {
   $sw_fs=9;
   $fs = $wb->add_format();
   $fs->set_bold();
   $fs->set_color('white');
   $fs->set_fg_color('green');
   $fs->set_align('center');
   $fs->set_border('1');
   }
if ( $_ =~ "INFORMACION|HARDWARE|INFORMATION" ) {
   $sw_fs=3;
#   print "$_ \n";
#   $input = <STDIN>;
   $fs = $wb->add_format();
   $fs->set_bold(1);
   $fs->set_size(11);
   $fs->set_font('Calibri');
   $fs->set_color('white');
   $fs->set_fg_color('Blue');
   $fs->set_border('1');
   }
#print "$_ \n";
#print "$row \n";
#print "$sw_fs \n";
#$input = <STDIN>;
else {
     if ( $_ =~ "WWN" ) {
        $sw_fs=1;
        $fs = $wb->add_format();
        $fs->set_bold();
        $fs->set_color('black');
        $fs->set_fg_color('yellow');
        $fs->set_align('center');
        $fs->set_border('2');
        }
     }
## Termino validacion colores
#
# Inicio impresion de las columnas por linea o registro leida
#
foreach $token (@Fld) {
#print "$token \n";
#print "$col \n";
#$input = <STDIN>;
$token =~ s/no //g;
$token =~ s/si //g;
        if ( $sw_fs > 8 ) {
           if ( $col == 5 ) {
               $excel->write($row, $col, $token, $fs);
               $sw_fs=0;
               }
            else {
                 $excel->write($row, $col, $token, $format);
                 }
            }
        else {
        if ( $sw_fs > 5 ) {
           $excel->write($row, $col, $token, $fs);
           $excel->merge_cells($row,$col,$row, 4);
           $sw_fs=0;
          }
        else {
        if ( $sw_fs > 2 ) {
           $excel->write($row, $col, $token, $fs);
           $excel->merge_cells($row,$col,$row, 4);
           }
        else {
        if ( $sw_fs > 0 ) {
           $excel->write($row, $col, $token, $fs);
           $excel->merge_cells($row,$col,$row, 13);
           $sw_fs=0;
           }
        else {
             $excel->write($row, $col, $token, $format);
             }
           }
         }
       }
        $col++;
        }
# Termino impresion de las columnas por linea leida y retorno a leer otra linea o registro
$sw_fs=0;
$row++;
        }
# Termino lectura del archivo y salgo
}
##########################################################
#    $input = <STDIN>;
#$input = <STDIN>;
#    my %colors = (
#                    0x08, 'black',
#                    0x0C, 'blue',
#                    0x10, 'brown',
#                    0x0F, 'cyan',
#                    0x17, 'gray',
#                    0x11, 'green',
#                    0x0B, 'lime',
#                    0x0E, 'magenta',
#                    0x12, 'navy',
#                    0x35, 'orange',
#                    0x21, 'pink',
#                    0x14, 'purple',
#                    0x0A, 'red',
#                    0x16, 'silver',
#                    0x09, 'white',
#                    0x0D, 'yellow',
#                 );
#    
#    my $worksheet1 = $workbook->add_worksheet('Named colors');
#
