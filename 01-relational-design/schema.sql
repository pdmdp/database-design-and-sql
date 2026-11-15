-- Transcribed from the submitted report; table and column names are retained.

create table voters (
     voter_tax_code varchar(20),
    voter_name varchar(20),
    voter_region_of_residence varchar(20),
    primary key (voter_tax_code) 
);

create table political_parties (
     party_name varchar(20),
    party_year_of_foundation integer,
    primary key (party_name) 
);

create table membership (
     voter_tax_code varchar(20),
    party_name varchar(20),
    membership_date date,
    primary key (voter_tax_code, party_name),
    foreign key (voter_tax_code) references voters,
    foreign key (party_name) references political_parties 
);

create table levels (
     level_name varchar(20),
    primary key (level_name) 
);

create table electoral_cards (
     card_number integer,
    party_name_cards varchar(20),
    voter_tax_code varchar(20) not null,
    level_name varchar(20) not null,
    primary key (card_number, voter_tax_code),
    foreign key (voter_tax_code) references voters on delete cascade,
    foreign key (level_name) references levels 
);

create table coalitions (
     coalition_name varchar(20),
    primary key (coalition_name) 
);

create table joining (
     party_name varchar(20),
    coalition_name varchar(20),
    primary key (party_name, coalition_name),
    foreign key (party_name) references political_parties,
    foreign key (coalition_name) references coalitions 
);

create table political_wings (
     wing_name varchar(20),
    primary key (wing_name) 
);

create table organized_into (
     party_name varchar(20),
    wing_name varchar(20),
    director varchar(20),
    primary key (party_name, wing_name),
    foreign key (party_name) references political_parties,
    foreign key (wing_name) references political_wings 
);

create table committe_members (
     member_id varchar(20),
    start_date date,
    party_name varchar(20) not null,
    primary key (member_id),
    foreign key (party_name) references political_parties 
);

create table officials (
     member_id varchar(20),
    primary key (member_id),
    foreign key (member_id) references committe_members on delete cascade 
);

create table candidates (
     member_id varchar(20),
    number_of_elections integer,
    primary key (member_id),
    foreign key (member_id) references committe_members on delete cascade 
);

create table elections (
     election_id varchar(10),
    election_date date not null,
    primary key (election_id) 
);

create table funding (
     coalition_name varchar(20),
    election_id varchar(10),
    member_id varchar(20),
    funding_amounts integer,
    primary key (coalition_name, election_id, member_id),
    foreign key (coalition_name) references coalitions,
    foreign key (election_id) references elections,
    foreign key (member_id) references committe_members 
);

create table mentoring (
     voter_tax_code varchar(20),
    party_name varchar(20),
    member_id varchar(20) not null,
    primary key (voter_tax_code, party_name),
    foreign key (voter_tax_code, party_name) references membership,
    foreign key (member_id) references officials 
);
