-- terminal: psql -h localhost -p 5432 -U demo -d demo


/*
CREATE TABLE имя-таблицы (
    имя-поля тип-данных [ограничения-целостности],
    имя-поля тип-данных [ограничения-целостности],
    ...
    имя-поля тип-данных [ограничения-целостности],
    [ограничение-целостности],
    [первичный-ключ],
    [внешний-ключ]);
*/
create table aircrafts (
    aircraft_code char(3) not null,
    model text not null,
    range integer not null,
    check (range > 0),
    primary key (aircraft_code)
);

/*
INSERT INTO имя-таблицы [(имя-атрибута, имя-атрибута, ... )]
VALUES (значение-атрибута, значение-атрибута, ... );
*/
insert into aircrafts (aircraft_code, model, range)
values ('SU9', 'Sukhoi SuperJat-100', 3000);

insert into aircrafts (aircraft_code, model, range)
values ('773', 'Boeing 777-300', 11100 ),
       ('763', 'Boeing 767-300', 7900 ),
       ('733', 'Boeing 737-300', 4200 ),
       ('320', 'Airbus A320-200', 5700 ),
       ('321', 'Airbus A321-200', 5600 ),
       ('319', 'Airbus A319-100', 6700 ),
       ('CN1', 'Cessna 208 Caravan', 1200 ),
       ('CR2', 'Bombardier CRJ-200', 2700 );

select * from aircrafts order by model

create table seats (
    aircraft_code char(3) not null,
    seat_no varchar(4) not null,
    fare_conditions varchar(10) not null
    check (
        fare_conditions in ('Economy', 'Comfort', 'Business')
        ),
    primary key (aircraft_code, seat_no),
    foreign key (aircraft_code)
        references aircrafts (aircraft_code)
        on delete cascade
);

insert into seats values
    ('SU9', '1A','Business' ),
    ('SU9','1B','Business' ),
    ('SU9','10A','Economy' ),
    ('SU9','10B','Economy' ),
    ('SU9','10F','Economy' ),
    ('SU9','20F','Economy' );


/*  --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- */
-- №3
select * from aircrafts;
update aircrafts
  set range = range * 2
  where aircraft_code='SU9';
select * from aircrafts;
