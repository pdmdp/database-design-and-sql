-- query1
-- Find the name of the “veteran” voters. Veteran voters are voters that have 
-- the oldest membership date to some party with respect to all the other voters. 
-- If a voter has no membership to some party, this voter is not a veteran.
select distinct v.voter_name
from voters v
join memberships m on m.memb_voter = v.voter_tax_code
where m.memb_join_date = (
  select min(m2.memb_join_date)
  from memberships m2
);

-- query2
-- Find the ids of officials that mentored at least two memberships
select o.official_id
from memberships m
join officials o on m.memb_mentor = o.official_id
group by official_id
having count(m.memb_mentor) >= 2
;


-- query 3
-- Find the ids of committee members that have received the largest
-- amount of money in funding, i.e., the total amount of money 
-- received is the largest amount w.r.t. the total amounts of money 
-- received by other committee members. Here we are only interested 
-- in committee members that received at least one funding.

with total_funding as (
    select funded_committee, sum(funding_amount) as fund_tot
    from fundings
    group by funded_committee
)

select funded_committee
from total_funding
where fund_tot = (
    select max(fund_tot)
    from total_funding
);


-- query 4
-- Find the ids of the coalitions that never sponsored a committee 
-- member belonging to a party that refers to a wing called ‘Wing42’. 
-- Note that a coalition that has never funded any committee member is 
-- also part of the result.

with removed_coalitions as (
  select distinct f.funder_coalition as coalition_id
  from fundings f
  join committee_members cm on f.funded_committee = cm.committee_id
  join wings_organizations wo on cm.committee_party = wo.party
  where wo.wing = 'Wing42'
)
select c.coalition_id
from coalitions c
left join removed_coalitions r on r.coalition_id = c.coalition_id
where r.coalition_id is null;


-- query 5
-- For each voter, retrieve the number of parties to which the voter has
-- a membership since 2023-03-01 (included). If a voter participates to 
-- no party, or it participates only to parties before 2023-03-01, you 
-- must report 0 for that voter. Note that the output of the query must 
-- be a set of tuples of the form (<voter_tax_code>, <number_of_parties>).

select v.voter_tax_code,
       count(distinct m.memb_party) as number_of_parties
from voters v
left join memberships m
  on m.memb_voter = v.voter_tax_code
 and m.memb_join_date >= date '2023-03-01'
group by v.voter_tax_code
order by v.voter_tax_code;


-- query 6
-- Find the voter tax code of the voters that are members of the highest 
-- number of parties (among all voters) in which at least 2 committee 
-- members participate. Note that if no voter is a member of a party 
-- with at least 2 committee members, then the result of the query is empty.

with eligible_parties as (
  select cm.committee_party
  from committee_members cm
  group by cm.committee_party
  having count(cm.committee_id) >= 2
),
voter_counts as (
  select m.memb_voter as voter_tax_code,
         count(distinct m.memb_party) as num_parties
  from memberships m
  join eligible_parties ep
    on ep.committee_party = m.memb_party
  group by m.memb_voter
)

select vc.voter_tax_code
from voter_counts vc
where vc.num_parties = (
  select max(num_parties)
  from voter_counts
);


-- query 7
-- Find the tax code of voters that have only memberships to parties
-- that belong to some coalition. Note that if a voter has no 
-- memberships, the voter is also part of the result.

with bad_voters as (
  select distinct m.memb_voter
  from memberships m
  left join parties_in_coalitions pic
    on pic.party_name = m.memb_party
  where pic.party_name is null
)

select v.voter_tax_code
from voters v
left join bad_voters b
  on b.memb_voter = v.voter_tax_code
where b.memb_voter is null
order by v.voter_tax_code
;


-- query 8
-- Find the names of the parties that are in the top 2 in the ranking 
-- of the parties with the highest number of voters.  For example, 
-- assume the largest number of voters in a party are, from higher to 
-- lower, 300, 280, 270, 200, ... and assume we have 2 parties in total 
-- with 300 voters, and 4 parties in total with 280 voters. The query 
-- will return 2 + 4 = 6 parties in total, where the first 2 are the 
-- parties with 300 voters, and then we have the 4 parties with 
-- 280 voters. For parties that have the same amount of voters, 
-- show them in any order you like.

with party_counts as (
  select m.memb_party as party_name,
         count(distinct m.memb_voter) as num_voters
  from memberships m
  group by m.memb_party
),
top2_counts as (
  select distinct num_voters
  from party_counts
  order by num_voters desc
  limit 2
)

select pc.party_name
from party_counts pc
join top2_counts t
  on t.num_voters = pc.num_voters
order by pc.num_voters desc
;

