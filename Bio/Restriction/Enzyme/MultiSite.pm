# $Id$
#------------------------------------------------------------------
#
# BioPerl module Bio::Restriction::Enzyme::MultiSite
#
# Cared for by Heikki Lehvaslaiho, heikki@ebi.ac.uk
#
# You may distribute this module under the same terms as perl itself
#------------------------------------------------------------------

## POD Documentation:

=head1 NAME

Bio::Restriction::Enzyme::MultiSite - A single restriction endonuclease

=head1 SYNOPSIS

  # set up a single restriction enzyme. This contains lots of
  # information about the enzyme that is generally parsed from a
  # rebase file and can then be read back

  use Bio::Restriction::Enzyme;


=head1 DESCRIPTION

This module defines a restriction endonuclease class where one object
represents one of the distinct recognition sites for that enzyme. The
method L<others|others> stores references to other objects with
alternative sites.

In this schema each object within an EnzymeCollection can be checked
for matching a sequence.

=head1 FEEDBACK

=head2 Mailing Lists

User feedback is an integral part of the evolution of this and other
Bioperl modules. Send your comments and suggestions preferably to one
of the Bioperl mailing lists. Your participation is much appreciated.

   bioperl-l@bioperl.org              - General discussion
   http://bioperl.org/MailList.shtml  - About the mailing lists

=head2 Reporting Bugs

Report bugs to the Bioperl bug tracking system to help us keep track
the bugs and their resolution. Bug reports can be submitted via email
or the web:

    bioperl-bugs@bio.perl.org
    http://bugzilla.bioperl.org/

=head1 AUTHOR

Heikki Lehvaslaiho, heikki@ebi.ac.uk

=head1 CONTRIBUTORS

Rob Edwards, redwards@utmem.edu

=head1 COPYRIGHT

Copyright (c) 2003 Rob Edwards.

Some of this work is Copyright (c) 1997-2002 Steve A. Chervitz. All
Rights Reserved.  This module is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<Bio::Restriction::Enzyme>, L<Bio::Restriction::Analysis>, 
L<Bio::Restriction::EnzymeCollection>

=head1 APPENDIX

Methods beginning with a leading underscore are considered private and
are intended for internal use by this module. They are not considered
part of the public interface and are described here for documentation
purposes only.

=cut

package Bio::Restriction::Enzyme::MultiSite;
use Bio::Restriction::Enzyme;
use strict;

use Data::Dumper;

use vars qw (@ISA);
@ISA = qw(Bio::Restriction::Enzyme);

=head2 new

 Title     : new
 Function
 Function  : Initializes the enzyme object
 Returns   : The Restriction::Enzyme::MultiSite object
 Argument  : 

=cut

sub new {
    my($class, @args) = @_;
    my $self = $class->SUPER::new(@args);

    my ($others) =
            $self->_rearrange([qw(
                                  OTHERS
                                 )], @args);

    $others && $self->others($others);
    return $self;
}

=head2 others

 Title     : others
 Usage     : $re->vendor(@list_of_companies);
 Function  : Gets/Sets the a list of companies that you can get the enzyme from.
             Also sets the commercially_available boolean
 Arguments : A reference to an array containing the names of companies
             that you can get the enzyme from
 Returns   : A reference to an array containing the names of companies
             that you can get the enzyme from

Added for compatibility to REBASE

=cut

sub others {
    my $self = shift;
    push @{$self->{_others}}, @_ if @_;
    return @{$self->{'_others'}};
}


=head2 purge_others

 Title     : purge_others
 Usage     : $re->purge_references();
 Function  : Purges the set of references for this enzyme
 Arguments : 
 Returns   : 

=cut

sub purge_others {
    my ($self) = shift;
    $self->{_others} = [];

}


1;

