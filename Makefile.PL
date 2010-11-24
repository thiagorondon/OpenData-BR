#!/usr/bin/env perl

use inc::Module::Install;

name 'OpenData';
license 'perl';
version_from 'lib/OpenData.pm';

requires 'Moose';
requires 'MooseX::Traits';

requires 'namespace::autoclean';
requires 'Text::CSV';
requires 'LWP::Curl';
requires 'HTML::TreeBuilder::XPath';
requires 'MongoDB';
requires 'WWW::Mechanize';

recommends 'Text::CSV_XS' => '0.50';

test_requires  'Test::More';

tests 't/*.t t/*/*t t/*/*/*t t/*/*/*/*t';

auto_install;
WriteAll;

