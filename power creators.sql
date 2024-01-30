use interview_questions;

-- The linkedin creator team is looking for power creators who use their personal profile as a company or influencer page
-- if someone's linkedin page has more followers than the company they work for, we can safely assume that person is a power creator.
-- write a query  to return the ID'S of these linkedin power creators.

create table personal_profiles(profile_id int, name varchar(255), followers int);

insert into personal_profiles(profile_id, name, followers)
values(1, 'Nick Singh', 92000),
(2, 'Zach Wilson', 199000),
(3, 'Daliana Liu', 171000),
(4, 'Ravit Jain', 107000),
(5, 'Vin Vashishta', 139000),
(6, 'susan', 39000);

create table employee_company(personal_profile_id int, company_id int);

insert into employee_company(personal_profile_id, company_id)
values(1,4),
(1,9),
(2,2),
(3,1),
(4,3),
(5,6),
(6,5);

create table company_pages(company_id int, name varchar(255), followers int);

insert into company_pages(company_id, name, followers)
values(1, 'The data Science Postcast', 8000),
(2, 'Airbnb', 70000),
(3, 'The ravit show', 6000),
(4, 'Data Lemeur', 200),
(5, 'Youtube', 16000000),
(6, 'Data Science Vin', 4500),
(9, 'Ace the Data Science Interview', 4479);

select * from personal_profiles;

select * from employee_company;

select * from company_pages;

with cte as (
select ec.personal_profile_id, max(cp.followers) as max_followers from employee_company ec
inner join company_pages cp on ec.company_id = cp.company_id
group by ec.personal_profile_id)
select pp.name, pp.followers, cte.max_followers
from personal_profiles pp
inner join cte on pp.profile_id = cte.personal_profile_id
where pp.followers > cte.max_followers;