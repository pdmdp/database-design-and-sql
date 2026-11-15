select
	f.funding_date as funding_day,
	e.election_date as election_date,
	f.funder_coalition as coalition_id,
	cm.committee_party as party_name,
	sum(f.funding_amount) as total_funded_money
from fundings f
	join committee_members cm
 		on cm.committee_id = f.funded_committee
	join political_parties pp
 		on pp.party_name = cm.committee_party
	join elections e
 		on e.election_id = f.election_id
group by
 	f.funding_date,
 	e.election_date,
 	f.funder_coalition,
 	cm.committee_party;

select
    f.funding_date as funding_day,
    e.election_date as election_date,
    f.funder_coalition as coalition_id,
    cm.committee_party as party_name,
    count(*) as number_of_fundings
from fundings f
    join committee_members cm
        on cm.committee_id = f.funded_committee
    join political_parties pp
        on pp.party_name = cm.committee_party
    join elections e
        on e.election_id = f.election_id
group by
    f.funding_date,
    e.election_date,
    f.funder_coalition,
    cm.committee_party;
