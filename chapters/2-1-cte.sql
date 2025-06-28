-- Для текущей сессии
SET search_path TO bookings, public;

/* 2.1. Запросы с несколькими общими табличными выражениями */

-- 2.1.1
select
    td.departure_airport,
    a.airport_name,
    td.dep_pass_count,
    ta.arr_pass_count,
    td.dep_pass_count + td.dep_pass_count as total_pass_count

from (select
          f.departure_airport,
          count(*) as dep_pass_count
      from boarding_passes as bp
      join flights as f on f.flight_id = bp.flight_id
      where f.status in ('Arrived', 'Departed')
        and f.scheduled_departure >= bookings.now() - '1 mon'::interval
      group by f.departure_airport) as td   -- total_departed_pass_counts

join (select
          f.arrival_airport,
          count(*) as arr_pass_count
      from boarding_passes as bp
      join flights as f on f.flight_id = bp.flight_id
      where f.status in ('Arrived', 'Departed')
        and f.scheduled_departure >= bookings.now() - '1 mon'::interval
      group by f.arrival_airport) as ta   -- total_arrived_pass_counts
    on td.departure_airport = ta.arrival_airport

join airports as a
    on a.airport_code = td.departure_airport

order by total_pass_count desc;


-- 2.1.2
select
    td.departure_airport,
    a.airport_name,
    td.dep_pass_count,
    ta.arr_pass_count,
    td.dep_pass_count + ta.arr_pass_count as total_pass_count

from (select
          f.departure_airport,
          sum(pass_count) as dep_pass_count
      from (select
                flight_id,
                count(*) as pass_count
            from boarding_passes
            group by flight_id) as bp
      join flights as f on f.flight_id = bp.flight_id
      where f.status in ('Arrived', 'Departed')
        and f.scheduled_departure >= bookings.now() - '1 mon'::interval
      group by f.departure_airport) as td   -- total_departed_pass{counts

join (select
          f.arrival_airport,
          sum(pass_count) as arr_pass_count
      from (select
                flight_id,
                count(*) as pass_count
            from boarding_passes
            group by flight_id) as bp
      join flights as f on f.flight_id = bp.flight_id
      where f.status in ('Arrived', 'Departed')
        and f.scheduled_departure >= bookings.now() - '1 mon'::interval
      group by f.arrival_airport) as ta -- total_arrived_pass_counts
    on td.departure_airport = ta.arrival_airport

join airports as a
    on a.airport_code = td.departure_airport

order by total_pass_count desc;


-- 2.1.3
with
    bp as (
        select
            flight_id,
            count(*) as pass_count
        from boarding_passes
        group by flight_id
    )

select
    td.departure_airport,
    a.airport_name,
    td.dep_pass_count,
    ta.arr_pass_count,
    td.dep_pass_count + ta.arr_pass_count as total_pass_count

from (select
          f.departure_airport,
          sum(pass_count) as dep_pass_count
      from bp as bp
      join flights as f on f.flight_id = bp.flight_id
      where f.status in ('Arrived', 'Departed')
        and f.scheduled_departure >= bookings.now() - '1 mon'::interval
      group by f.departure_airport) as td   -- total_departed_pass{counts

join (select
          f.arrival_airport,
          sum(pass_count) as arr_pass_count
      from bp as bp
      join flights as f on f.flight_id = bp.flight_id
      where f.status in ('Arrived', 'Departed')
        and f.scheduled_departure >= bookings.now() - '1 mon'::interval
      group by f.arrival_airport) as ta -- total_arrived_pass_counts

    on td.departure_airport = ta.arrival_airport

join airports as a
    on a.airport_code = td.departure_airport
order by total_pass_count desc;


-- 2.1.4
with
    bp as (
        select
            flight_id,
            count(*) as pass_count
        from boarding_passes
        group by flight_id
    ),

    total_departed_pass_counts as (
        select
            f.departure_airport,
            sum(bp.pass_count) as dep_pass_count
        from bp as bp
        join flights as f on f.flight_id = bp.flight_id
        where f.status in ('Arrived', 'Departed')
          and f.scheduled_departure >= bookings.now() - '1 mon'::interval
        group by f.departure_airport
    ),

    total_arrived_pass_counts as (
        select
          f.arrival_airport,
          sum(pass_count) as arr_pass_count
      from bp as bp
      join flights as f on f.flight_id = bp.flight_id
      where f.status in ('Arrived', 'Departed')
        and f.scheduled_departure >= bookings.now() - '1 mon'::interval
      group by f.arrival_airport
    )

select
    td.departure_airport,
    a.airport_name,
    td.dep_pass_count,
    ta.arr_pass_count,
    td.dep_pass_count + ta.arr_pass_count as total_pass_count
from total_departed_pass_counts as td
join total_arrived_pass_counts as ta on td.departure_airport = ta.arrival_airport
join airports as a on a.airport_code = td.departure_airport
order by total_pass_count;


-- 2.1.5
with
    bp as (
        select
            flight_id,
            count(*) as pass_count
        from boarding_passes
        group by flight_id
    ),

    flights_pass_count as (
      select
            f.departure_airport,
            f.arrival_airport,
            bp.pass_count
        from bp as bp
        join flights as f on f.flight_id = bp.flight_id
        where f.status in ('Arrived', 'Departed')
          and f.scheduled_departure >= bookings.now() - '1 mon'::interval
    ),

    total_departed_pass_counts as (
        select
            departure_airport,
            sum(pass_count) as dep_pass_count
        from flights_pass_count
        group by departure_airport
    ),

    total_arrived_pass_counts as (
        select
          arrival_airport,
          sum(pass_count) as arr_pass_count
      from flights_pass_count
      group by arrival_airport
    )

select
    td.departure_airport,
    a.airport_name,
    td.dep_pass_count,
    ta.arr_pass_count,
    td.dep_pass_count + ta.arr_pass_count as total_pass_count
from total_departed_pass_counts as td
join total_arrived_pass_counts as ta on td.departure_airport = ta.arrival_airport
join airports as a on a.airport_code = td.departure_airport
order by total_pass_count;


-- 2.1.6
with
    bp as (
        select
            flight_id,
            count(*) as pass_count
        from boarding_passes
        group by flight_id
    ),

    flights_pass_count as (
        select
            f.departure_airport,
            f.arrival_airport,
            bp.pass_count
        from bp as bp
        join flights as f on f.flight_id = bp.flight_id
        where f.status in ('Arrived', 'Departed')
          and f.scheduled_departure >= bookings.now() - '1 mon'::interval
    ),

    total_departed_pass_counts as (
        select
            departure_airport,
            sum(pass_count) as dep_pass_count
        from flights_pass_count
        group by departure_airport
    ),

    total_arrived_pass_counts as (
        select
          arrival_airport,
          sum(pass_count) as arr_pass_count
      from flights_pass_count
      group by arrival_airport
    ),

    results as (
        select
            td.departure_airport,
            a.airport_name,
            td.dep_pass_count,
            ta.arr_pass_count,
            td.dep_pass_count + ta.arr_pass_count as total_pass_count
        from total_departed_pass_counts as td
        join total_arrived_pass_counts as ta on td.departure_airport = ta.arrival_airport
        join airports as a on a.airport_code = td.departure_airport
    )

select * from results
order by total_pass_count;