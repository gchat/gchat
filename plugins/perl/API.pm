# line 1 "API.pm"
BEGIN {
    $INC{"$_.pm"} = 1 foreach qw(
        API Network Channel User
        GChat GChat::IRC GChat::IRC::Server
        GChat::IRC::Channel GChat::IRC::User
    )
}

package API;

sub get_module {1
}

package GChat;

sub EAT_ALL () { Xchat::EAT_ALL }

# GChat->print()
sub print {
    my (undef, $text) = (shift, shift);
    return unless defined $text;
	Xchat::Internal::print($text);
}

# GChat->print()
sub command {
    shift;
    Xchat::Interal::command(@_);
}

package Command;

# on Command $cmd => $code, %options
# this isn't really evented - it just looks like it is.
sub on {
    my (undef, $cmd, $code, %options) = @_;
    my $module = API::get_module(caller) or return;
    my $hook   = Xchat::Internal::hook_command(
        $cmd,
        Xchat::PRI_NORM,
        sub { $code->(); Xchat::EAT_ALL(); },
        $options{help},
        $options{data}
    ) or return;
    GChat->print($hook);
}

1
