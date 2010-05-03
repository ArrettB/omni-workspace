#!/usr/bin/perl

$flag = 0;
TOP: while( $line = <> ) {
    if( $flag == 0 &&  $line =~ /.* Object:  View .*/ ) {
        print $line;
        $flag = 1;
        next TOP;
    }

    if( $flag == 1 ) {
        if( $line =~ /.* Object:  View .*/ ) {
            print $line;
        } elsif ( $line =~ /.* Object: .*/ ) {
            $flag = 0;
        } else {
            print $line;
        }
    }
}
