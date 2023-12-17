#!/usr/bin/perl
use strict;
use warnings;

use constant { 
	INSURANCE_NONE => 'none', 
};

# Patients Array
my @patients;

sub calculate_age {
	my ($dob) = @_;
    
	my ($year, $month, $day) = split('-', $dob);
	my ($current_year, $current_month, $current_day) = (localtime)[5,4,3];
	# assigns current year, month and day to current_year, current_month, and current_day
		
	$current_year += 1900;
	$current_month += 1;
    my $age = $current_year - $year;
    
	$age-- if ($current_month < $month || ($current_month == $month && $current_day < $day));
	
	return $age;
}

sub generate_pin {
	return int(rand(9000)) + 1000;
}

# for entering a new patient
sub new_patient {
	print "Enter patient information - \n";
	
	print "Last Name - ";
	my $last_name = <STDIN>;
	chomp($last_name);
	unless ($last_name =~ /^[A-Za-z]+$/) {
        print "Invalid. Name must contain no numbers\n";
        return;
	}
	
	print "First Name - ";
	my $first_name = <STDIN>;
	chomp($first_name);
	unless ($first_name =~ /^[A-Za-z]+$/) {
        print "Invalid. Name must contain no numbers\n";
        return;
    }
	
	print "Middle Initial - ";
	my $middle_initial = <STDIN>;
	chomp($middle_initial);
	unless ($middle_initial =~ /^[A-Za-z]$/) {
        print "Must be single letter for initial\n";
        return;
    }
	
	print "Date of Birth (YYYY-MM-DD) - ";
	my $dob = <STDIN>;
	chomp($dob);
	unless ($dob =~ /^\d{4}-\d{2}-\d{2}$/) {
        print "Please format DOB as such - YYYY-MM-DD\n";
        return;
    }
	
	print "Insurance Carrier (if none, enter 'none') - ";
	my $insurance = <STDIN>;
	chomp($insurance);
	
	print "Ailment (Reason for visit) - ";
	my $ailment = <STDIN>;
	chomp($ailment);
	
	my $age = calculate_age($dob);
	my $pin = generate_pin();
	
	# New patient entry to @patients
	my %patient = (
		last_name => $last_name,
		first_name => $first_name,
		middle_initial => $middle_initial,
		dob => $dob,
		insurance => $insurance,
		ailment => $ailment,
		age => $age,
		pin => $pin,
	);
	
	push @patients, \%patient;
	
	foreach my $patient_ref (@patients) {
		my %patient_info = %{$patient_ref};
		
		my $full_name = "$patient_info{first_name} $patient_info{middle_initial} $patient_info{last_name}";
		my $age = "$patient_info{age}";
		my $ailment = "$patient_info{ailment}";
		my $pin = "$patient_info{pin}";
		
		print "Full Name - $full_name\n";
		print "Age - $age\n";
		print "Ailment - $ailment\n";
		print "PIN Number - $pin\n";
	}
	
	print "Press any key to return to the main menu...";
	<STDIN>;
}

# processing patients at the end of day
sub end_shift {
	print "Processing Patients - \n";
	for my $patient (@patients) {
		print "\n";
		print "Full Name - $patient->{first_name} $patient->{middle_initial}. $patient->{last_name}\n";
		print "Age - $patient->{age}\n";
		print "Ailment - $patient->{ailment}\n";
		print "PIN - $patient->{pin}\n";
		
		if ($patient->{insurance} eq INSURANCE_NONE) {
			print "*** Billing Department: Patient without insurance ***\n";
		}
	}
	@patients = ();
	print "Press any key to return to the main menu...";
	<STDIN>;
}

sub main {
	while (1) {
		print "\n~ MAIN MENU ~\n";
		print "1 - ADD PATIENT\n";
		print "2 - END SHIFT\n";
		print "3 - EXIT\n";
		print "Select activity (1-3) - ";
		my $choice = <STDIN>;
		chomp($choice);
		
		if ($choice =~ /^\d+$/ && $choice >= 1 && $choice <= 3) {
			if ($choice == 1) {
				new_patient();
			} elsif ($choice == 2) {
				end_shift();
			} elsif ($choice == 3) {
				print "Are you sure you would like to exit? (y/n) - ";
				my $confirm = <STDIN>;
				chomp($confirm);
				
				# "Safety Net" confirming exit
				if (lc($confirmation) eq 'y') {
                    last;
                }
			}
		} else {
			print "Selection Invalid\n";
		}
	}
}

main();